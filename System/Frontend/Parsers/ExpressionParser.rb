#! /usr/bin/env ruby

##
# Expression parser parses an expression with logic operators,
# relational operators and math operators following these rules
#
#```
# expression
# | relExp 
# | '(' relExp ')' 
# | relExp '&&' relExp 
# | relExp '||' relExp
# | '!' relExp
# ;
# relExp
# | sum
# | sum '==' sum
# | sum '>=' sum
# | sum '<=' sum
# | sum '>' sum
# | sum '<' sum
# ;
# sum
# | prod
# | '-' prod
# | prod '+' prod
# | prod '-' prod
# ;
# prod
# | power
# | power '*' power
# | power '/' power
# | power '\' power
# | power '%' power
# ;
# power
# | atom
# | atom ^ atom
# ;
# atom
# | local_ID
# | global_ID
# | number
# | abs
# | sym
# | INF
# | NINF
# | e
# | PI
# | math_funct
# | calls
# ;
# abs
# | '|' sum '|'
# ;
# sym
# | '${' sum '}'
# math_funct
# | 'log(' sum ')'
# | 'exp(' sum ')'
# | 'cos(' sum ')'
# | 'acos(' sum ')'
# | 'sin(' sum ')'
# | 'asin(' sum ')'
# | 'tan(' sum ')'
# | 'atan(' sum ')'
# | 'sqrt(' sum ')'
# ;
# calls
# | local_ID '.' call
# | global_ID '.' call
# | global_ID '(' params ')'
# | call
# ;
# call
# | local_ID '(' params ')'
# | local_ID '[' index ']'
# | global_ID '[' index ']'
# | local_ID '.' local_ID '(' params ')'
# ;
# params
# | params ',' param
# | param
# ;
# param
# | expression
# ;
# index
# | index ',' ind
# | ind
# ;
# ind
# | sum
# ;
# ```
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ExpressionParser < TDparser


  # Same of TDparser
  #
  # * **argument**: Scanner (or parser)
  def initialize(scanner)
    super(scanner)
    @@sym = false unless defined? @@sym and @@sym
  end
  
  # Same as parseExpression()
  #
  # * **argument**: token to begin
  # * **returns**: ICode AST
  def parse(token)
    return parseExpression(token)
  end
  
  protected
  
    # Same as parseSum()
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseSimpleExp(token)
      return parseSum(token)
    end
  
  private
  
    # Parses an expression from logic operators
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseExpression(token)
    
      tkType = token.getType  
      
      root = parseSubExp(token)
      
      if tkType == TkType.NOT then
        node = ICodeGen.generateNode(OpOpTr.getICType(tkType))
        node.addBranch(root)
        root = node
      end
      
      token = currentTk   
      tkType = token.getType
      
      while BoolOpTr.include? tkType
        
        nextTk
        skipEol
        token = currentTk
        node  = ICodeGen.generateNode(BoolOpTr.getICType(tkType))
        node.addBranch(root)
        node.addBranch(parseSubExp(token))
        root   = node
        token  = currentTk
        tkType = token.getType
        
      end
      
      return root
    
    end
    
    # Parses a sub expression from logic operators
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseSubExp(token)
    
      tkType = token.getType
      
      if tkType == TkType.L_PAR
      
        nextTk
        skipEol
        token = currentTk
        root  = parseExpression(token)
        token = currentTk
        if token.getType != TkType.R_PAR
          @errHandler.flag(token,ErrCode.MISSING_R_PAR,self)
        else
          nextTk
        end
      
      else

        root  = parseRel(token)
      end
      
      return root
    
    end
    
    # Parses a relational expression
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseRel(token)
    
      root   = parseSum(token)
      tkType = currentTk.getType
      
      if OpOpTr.include? tkType
        
        node = ICodeGen.generateNode(OpOpTr.getICType(tkType))
        nextTk
        skipEol
        token = currentTk
        node.addBranch(root)
        node.addBranch(parseSum(currentTk))
        root   = node
      
      end
      
      return root
    
    end
    
    # Parses a sum expression
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseSum(token)
    
      tkType = token.getType
    
      if AddOp.include? tkType
        sign  = tkType
        token = nextTk
      end
      
      root   = parseProd(token)    
      if sign == TkType.MINUS
        node = ICodeGen.generateNode(ICodeNType.INVERT)
        node.addBranch(root)
        root = node
      end
      
      token  = currentTk
      tkType = token.getType
      
      while AddOp.include? tkType
      
        node  = ICodeGen.generateNode(OpOpTr.getICType(tkType))
        nextTk
        skipEol
        token = currentTk
        node.addBranch(root)
        node.addBranch(parseProd(token))
        root   = node
        token  = currentTk
        tkType = token.getType
         
      end
      
      return root
      
    end
    
    # Parses a product expression
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseProd(token)
    
      root   = parsePow(token)
      token  = currentTk
      tkType = token.getType
      while ProdOp.include? tkType
      
        node = ICodeGen.generateNode(OpOpTr.getICType(tkType))
        nextTk
        skipEol
        token = currentTk
        node.addBranch(root)
        node.addBranch(parsePow(currentTk))
        root   = node
        token  = currentTk
        tkType = currentTk.getType
        
      end
      
      return root
    
    end
    
    # Parses a power expression
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parsePow(token)
    
      stack = []
      stack.push parseAtom(token)
      
      # nextTk
      tkType = currentTk.getType
      
      while tkType == TkType.POWER
        nextTk
        skipEol
        token = currentTk
        stack.push parseAtom(currentTk)
        tkType = currentTk.getType
      end
      
      while stack.size > 1
        rightN = stack.pop
        leftN  = stack.pop
        node = ICodeGen.generateNode(ICodeNType.POWER)
        node.addBranch(leftN)
        node.addBranch(rightN)
        stack.push node
      end
      
      return stack.pop
    
    end
    
    # Parses operands
    #
    # * **argument**: token to begin
    # * **returns**: ICode AST
    def parseAtom(token)
      
      tkType = token.getType
      
      case tkType
                
        when TkType.G_IDENT, TkType.L_IDENT
        
          idParser = IDparser.new(self)
          root     = idParser.parse(token)
          
        when TkType.INT
        
          root = ICodeGen.generateNode(ICodeNType.INT)
          root.setAttr(ICKey.VALUE,token.getValue)
          
          nextTk
          
        when TkType.FLOAT
        
          root = ICodeGen.generateNode(ICodeNType.IFLOAT)
          root.setAttr(ICKey.VALUE,token.getValue)
          
          nextTk
          
        when TkType.STRING
        
          root = ICodeGen.generateNode(ICodeNType.STRING_CONST)
          root.setAttr(ICKey.VALUE,token.getValue)
          
          nextTk
          
        when TkType.L_PAR
        
          nextTk
          root = parseSum(currentTk)
          
          if not currentTk.getType == TkType.R_PAR then
            @errHandler.flag(currentTk,ErrCode.MISSING_R_PAREN,self)
          else
            nextTk
          end
          
        when TkType.DOLLAR
          @@sym = true
          nextTk
          
          if not currentTk.getType == TkType.L_BRACE then
            @errHandler.flag(currentTk,ErrCode.MISSING_L_BRACE,self)
          else
            nextTk
          end
          
          branch = parseSum(currentTk)
          root = ICodeGen.generateNode(ICodeNType.SYMBOLIC)
          root.addBranch(branch)
          
          if not currentTk.getType == TkType.R_BRACE then
            @errHandler.flag(currentTk,ErrCode.MISSING_R_BRACE,self)
          else
            nextTk
          end
          @@sym = false 
          
        when TkType.ABS
        
          nextTk
          
          branch = parseSum(currentTk)
          root = ICodeGen.generateNode(ICodeNType.ABS)
          root.addBranch(branch)
          
          if not currentTk.getType == TkType.ABS then
            @errHandler.flag(currentTk,ErrCode.MISSING_END_ABS,self)
          else
            nextTk
          end
          
        when TkType.INF, TkType.NINF
        
          @errHandler.flag(currentTk,ErrCode.UNEXPECTED_INF,self) unless @@sym
          root = ICodeGen.generateNode(ICodeNType.INF)  if currentTk.getType == TkType.INF 
          root = ICodeGen.generateNode(ICodeNType.NINF) if currentTk.getType == TkType.NINF
          root.setAttr(ICKey.VALUE,currentTk.getText.upcase)
          nextTk
          
        when TkType.E, TkType.PI
        
          root = ICodeGen.generateNode(ICodeNType.CONST)
          root.setAttr(ICKey.VALUE,currentTk.getType.to_s)
          nextTk
          
        when TkType.TRUE, TkType.FALSE
          
          @errHandler.flag(currentTk,ErrCode.UNEXPECTED_BOOL,self) if @@sym
          root = ICodeGen.generateNode(ICodeNType.BOOL_CONST)
          root.setAttr(ICKey.VALUE,currentTk.getType.to_s)
          nextTk
          
        when TkType.NOT
          
          @errHandler.flag(currentTk,ErrCode.UNEXPECTED_LOGIC_OP,self) if @@sym
          root = ICodeGen.generateNode(ICodeNType.NOT)
          nextTk
          root.addBranch(parseExpression(currentTk))
          
        when TkType.L_BRACKET
        
          matrixParser = MatrixParser.new(self)
          root         = matrixParser.parse(currentTk)
          
        else
        
          if MathFunct.include? token.getType
            root = ICodeGen.generateNode(ICodeNType.MATH_FUNCT)
            funct = token.getType
            nextTk
            
            if currentTk.getType != TkType.L_PAR
              @errHandler.flag(currentTk,ErrCode.MISSING_L_PAR,self)
            else
              nextTk
            end
            
            arg = parseSum(currentTk)
            root.setAttr(ICKey.VALUE,funct)
            root.setAttr(ICKey.ARG,arg)
            
            if currentTk.getType != TkType.R_PAR
              @errHandler.flag(currentTk,ErrCode.MISSING_R_PAR,self)
            else
              nextTk
            end
            
          else
            
            @errHandler.flag(currentTk,ErrCode.UNEXPECTED_TK,self)
            
          end
        
      end
      
      return root
    
    end
          
end












