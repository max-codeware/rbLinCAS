#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ForParser < TDparser
  
  FOR_SYNC_SET = STMT_BEG_SET + [TkType.DOWNTO, TkType.TO, TkType.COLON]

  def initialize(source)
    super
  end
  
  def parse(token)
  
    token  = nextTk
    tkType = token.getType
    case tkType
      when TkType.L_IDENT
        id = @@symbolTabStack.enterLocal(token.getText)
        id.addLineNum(token.getLine)
        var = ICodeGen.generateNode(ICodeNType.LVARIABLE)
        var.setAttr(ICKey.ID,id)
      when TkType.G_IDENT
        
      else
        @errHandler.flag(token,ErrCode.MISSING_ID,self)
        id = @@symbolTabStack.enterLocal("dummyVar")
        id.addLineNum(token.getLine)
        var = ICodeGen.generateNode(ICodeNType.LVARIABLE)
        var.setAttr(ICKey.ID,id)
    end
    forNode    = ICodeGen.generateNode(ICodeNType.COMPOUND)
    loopNode   = ICodeGen.generateNode(ICodeNType.WHILE)
    assignNode = ICodeGen.generateNode(ICodeNType.ASSIGN)
    oneNode    = ICodeGen.generateNode(ICodeNType.NUM_CONST)
    
    oneNode.setAttr(ICKey.VALUE,1)
    assignNode.addBranch(var)
    
    nextTk
    token = sync(FOR_SYNC_SET)
    if token.getType == TkType.COLON then
      token = nextTk
    else
      @errHandler.flag(token,ErrCode.MISSING_COLON,self)
    end
    
    expParser = ExpressionParser.new(self)
    beginning = expParser.parse(token)
    assignNode.addBranch(beginning)
    forNode.addBranch(assignNode)
    
    token  = sync(FOR_SYNC_SET)
    tkType = token.getType
    case tkType
      when TkType.DOWNTO
        test = ICodeGen.generateNode(ICodeNType.GE)
        sumN = ICodeGen.generateNode(ICodeNType.SUB)
      when TkType.TO
        test = ICodeGen.generateNode(ICodeNType.SE)
        sumN = ICodeGen.generateNode(ICodeNType.ADD)
      else
        @errHandler.flag(token,ErrCode.MISSING_TO_DWTO,self)
        test = ICodeGen.generateNode(ICodeNType.SE)
        sumN = ICodeGen.generateNode(ICodeNType.ADD)
    end
    test.addBranch(var)
    sumN.addBranch(var)
    sumN.addBranch(oneNode)
    
    token = nextTk
    final = expParser.parse(token)
    test.addBranch(final)
    loopNode.addBranch(test)
    
    skipEol
    token     = currentTk
    blcParser = BlockParser.new(self)
    block     = blcParser.parse(token)
    
    finalAssignNode =  ICodeGen.generateNode(ICodeNType.ASSIGN)
    finalAssignNode.addBranch(var)
    finalAssignNode.addBranch(sumN)
    block.addBranch(finalAssignNode)
    loopNode.addBranch(block)
    forNode.addBranch(loopNode)
    
    token  = currentTk
    tkType = token.getType
    if tkType == TkType.EOL or tkType == TkType.SEMICOLON then
      nextTk
    else
      @errHandler.flag(token,ErrCode.MISSING_EOL,self)
    end
    
    return forNode
    
  end

end







