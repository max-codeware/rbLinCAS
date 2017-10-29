#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class WhileParser < TDparser

  WHILE_SET = STMT_BEG_SET + [TkType.WHILE]

  def initialize(source)
    super
  end
  
  def parse(token)
    
    node      = ICodeGen.generateNode(ICodeNType.WHILE)
    expParser = ExpressionParser.new(self)
    blcParser = BlockParser.new(self)
    
    token  = sync(WHILE_SET)
    tkType = token.getType
    if tkType == TkType.WHILE then
      token = nextTk
    else
      @errHandler.flag(token,ErrCode.MISSING_WHILE,self)
    end
    
    test = expParser.parse(token)
    if not test then
      @errHandler.flag(token,ErrCode.MISSING_CONDITION,self)
    else
      node.addBranch(test)
    end
    
    skipEol
    token = currentTk
    node.addBranch(blcParser.parse(token))
    
    token  = currentTk
    checkEol(token)
    
    return node
    
  end

end
