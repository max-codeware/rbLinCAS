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
  
    # Skipping `for` token
    token  = nextTk
    tkType = token.getType
    # Parsing counter identifier; if it is not found, a dummy one is created.
    case tkType
      when TkType.L_IDENT
        id = @@symTab.enterLocal(token.getText)
        id.addLineNum(token.getLine)
        var = ICodeGen.generateNode(ICodeNType.LVARIABLE)
        var.setAttr(ICKey.ID_PATH,id.getPath)
        @@symTab.exitLocal
      when TkType.G_IDENT
        id = @@symTab.enterGlobal(token.getText)
        id.addLineNum(token.getLine)
        var = ICodeGen.generateNode(ICodeNType.GVARIABLE)
        var.setAttr(ICKey.ID_PATH,id.getPath)
        @@symTab.exitLocal
      else
        @errHandler.flag(token,ErrCode.MISSING_ID,self)
        id = @@symTab.enterLocal("dummyVar")
        id.addLineNum(token.getLine)
        var = ICodeGen.generateNode(ICodeNType.LVARIABLE)
        var.setAttr(ICKey.ID_PATH,id.getPath)
        @symTab.exitLocal
    end
    
    # Creating basic nodes to represent a `for` statement
    forNode    = ICodeGen.generateNode(ICodeNType.COMPOUND)
    loopNode   = ICodeGen.generateNode(ICodeNType.WHILE)
    assignNode = ICodeGen.generateNode(ICodeNType.ASSIGN)
    oneNode    = ICodeGen.generateNode(ICodeNType.INT)
    
    oneNode.setAttr(ICKey.VALUE,1)
    assignNode.addBranch(var)
    
    nextTk
    token = sync(FOR_SYNC_SET)
    # Looking for a `COLON` token. if not found a sintax error wil be sent
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
    # Parsing loop direction; if missing `to` is default
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
    
    # Parsing `for` body
    skipEol
    token     = currentTk
    blcParser = BlockParser.new(self)
    block     = blcParser.parse(token)
    
    # Adding counter increase instruction to `for` body
    finalAssignNode =  ICodeGen.generateNode(ICodeNType.ASSIGN)
    finalAssignNode.addBranch(var)
    finalAssignNode.addBranch(sumN)
    block.addBranch(finalAssignNode)
    loopNode.addBranch(block)
    forNode.addBranch(loopNode)
    
    # Checking end of line
    token  = currentTk
    checkEol(token)
    
    return forNode
    
  end

end







