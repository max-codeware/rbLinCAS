#! /usr/bin/env ruby

class AssignParser < TDparser

  ASSIGN_TK  = [TkType.COLON_EQ, TkType.PLUS_EQ,
                TkType.MINUS_EQ, TkType.STAR_EQ,
                TkType.SLASH_EQ, TkType.BSLASH_EQ,
                TkType.MOD_EQ,   TkType.POWER_EQ]	

  ASSIGN_SET = STMT_BEG_SET + STMT_MID_SET + ASSIGN_TK

  def initialize(source)
    super(source)
  end
  
  def parse(token)
  
     root   = ICodeGen.generateNode(ICodeNType.ASSIGN)
     tkType = token.getType
     tkName = token.getText
     if IdentList.include? tkType then
     
       idParser = IDparser.new(self)
       idParser.ignoreUndef
       df = idParser.parse(token)
       
     else
       @errHandler.flag(token,ErrCode.MISSING_ID_ASSIGN,self)      
     end
     
     if df.getType == ICodeNType.CALL or df.getType == ICodeNType.METHOD_CALL
       return df
     else
       root.addBranch(df)
     end

     token  = sync(ASSIGN_SET)
     tkType = token.getType
     if not ASSIGN_TK.include? tkType
       @errHandler.flag(token,ErrCode.MISSING_COLON_EQ,self)
     else
       nextTk
     end
     
     expParser = ExpressionParser.new(self)
     rSide     = expParser.parse(currentTk)
     
     case tkType
         
       when TkType.PLUS_EQ
         sumNode = ICodeGen.generateNode(ICodeNType.ADD)
         sumNode.addBranch(varNode)
         sumNode.addBranch(rSide)
         root.addBranch(sumNode)
       when TkType.MINUS_EQ
         diffNode = ICodeGen.generateNode(ICodeNType.SUB)
         diffNode.addBranch(varNode)
         diffNode.addBranch(rSide)
         root.addBranch(diffNode)
       when TkType.STAR_EQ
         prodNode = ICodeGen.generateNode(ICodeNType.MULT)
         prodNode.addBranch(varNode)
         prodNode.addBranch(rSide)
         root.addBranch(prodNode)
       when TkType.SLASH_EQ
         fdivNode = ICodeGen.generateNode(ICodeNType.FDIV)
         fdivNode.addBranch(varNode)
         fdivNode.addBranch(rSide)
         root.addBranch(fdivNode)
       when TkType.BSLASH_EQ
         divNode = ICodeGen.generateNode(ICodeNType.IDIV)
         divNode.addBranch(varNode)
         divNode.addBranch(rSide)
         root.addBranch(divNode)
       when TkType.MOD_EQ
         modNode = ICodeGen.generateNode(ICodeNType.MOD)
         modNode.addBranch(varNode)
         modNode.addBranch(rSide)
         root.addBranch(modNode)
       when TkType.POWER_EQ
         powNode = ICodeGen.generateNode(ICodeNType.POWER)
         powNode.addBranch(varNode)
         powNode.addBranch(rSide)
         root.addBranch(powNode)
      # when TkType.APPEND
      #   appNode = ICodeGen.generateNode(ICodeNType.APPEND)
      #   appNode.addBranch(varNode)
      #   appNode.addBranch(rSide)
      #   root.addBranch(powNode)
       else
         root.addBranch(rSide)
         
     end
     
     token = currentTk
     checkEol(token) unless token.getType == TkType.R_BRACE
     
     return root
     
  end


  private
  
    class IdentEnum < Enum
     
      private
    
        enum_attr TkType.G_IDENT
        enum_attr TkType.L_IDENT
    
        List = []
    
        enum = IdentEnum.new
        self.public_instance_methods(false).each do |method|
          m = self.public_instance_method(method)
          m = m.bind(enum)
          List << m.call
        end
        enum = nil
    
      public
     
        def include?(_type)
          List.include? _type
        end 
      
    end
    IdentList = IdentEnum.new
    
end



    
    
    
    
    
    
    
