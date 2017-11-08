#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SelectParser < TDparser

  SELECT_SYNC_SET = [TkType.L_IDENT,
                     TkType.G_IDENT,
                     TkType.INT,
                     TkType.FLOAT,
                     TkType.PLUS,
                     TkType.MINUS,
                     TkType.STRING]
  CASE_SYNC_SET   = SELECT_SYNC_SET + [TkType.CASE,TkType.ELSE]
  
  def initialize(scanner)
    super(scanner)
    @cond = []
  end
  
  def parse(token)
    token = nextTk
    expParser = ExpressionParser.new(self)
    
    selectNode = ICodeGen.generateNode(ICodeNType.SELECT)
    selectNode.addBranch(expParser.parse(token)) if SELECT_SYNC_SET.include? token.getType
    skipEol
    token = currentTk
    if token.getType == TkType.L_BRACE then
      token = nextTk
    else
      @errHandler.flag(token,ErrCode.MISSING_L_BRACE,self)
    end
    skipEol
    
    while token.getType != TkType.R_BRACE and not token.is_a? EofToken
      token = sync(CASE_SYNC_SET)
      tkType = token.getType
      
      case tkType
        when TkType.CASE
          selectNode.addBranch(parseCase(token))
        when TkType.ELSE
          selectNode.addBranch(parseElse(token))
        else
          selectNode.addBranch(parseCase(token))
      end
      skipEol
      token = currentTk
    end
    
    tkType = token.getType
    if tkType == TkType.R_BRACE then
      token = nextTk
      checkEol(token)
    elsif tkType == TkType.EOF
      @errHandler.flag(token,ErrCode.UNEXPECTED_EOF,self)
    else
      @errHandler.flag(token,ErrCode.MISSING_R_BRACE,self)
    end
    
    selectNode
  end
  
 private
 
   def checkEol(token)
     tkType = token.getType
     if !(tkType == TkType.EOL or tkType == TkType.SEMICOLON) then
       @errHandler.flag(token,ErrCode.MISSING_EOL,self)
     else
       nextTk
     end
   end
   
   def parseCase(token)
     blcParser = BlockParser.new(self)
     
     tkType = token.getType
     if ! tkType == TkType.CASE
       @errHandler.flag(token,ErrCode.MISSING_CS_ES,self)
     else
       token = nextTk
       if !SELECT_SYNC_SET.include? token.getType
         @errHandler.flag(token,ErrCode.MISSING_CONDITION,self)
         noCond = true
       end
     end
     caseNode = ICodeGen.generateNode(ICodeNType.CASE)
     caseNode.addBranch(parseConditions(token)) unless noCond
     skipEol
     caseNode.addBranch(blcParser.parse(token))
     checkEol(currentTk)
     caseNode
   end
   
   def parseElse(token)
     blcParser = BlockParser.new(self)
     elseNode  = ICodeGen.generateNode(ICodeNType.ELSE)
     token = nextTk
     elseNode.addBranch(blcParser.parse(token))
     checkEol(currentTk)
     elseNode
   end
   
   def parseConditions(token)
     node      = ICodeGen.generateNode(ICodeNType.C_SETS)
     expParser = ExpressionParser.new(self)
     checkCond(token)
     node.addBranch(expParser.parse(token))
     token  = currentTk
     tkType = token.getType
     while tkType == TkType.COMMA
       token = nextTk
       checkCond(token)
       node.addBranch(expParser.parse(token))
       token = currentTk
       tkType = token.getType
     end
     node
   end
   
   def checkCond(token)
     if  ! SELECT_SYNC_SET.include? token.getType then
       @errHandler.flag(token,ErrCode.MISSING_CONDITION,self)
     end
   end

end








