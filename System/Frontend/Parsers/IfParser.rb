#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class IfParser < TDparser

  IF_SYNC_SET = STMT_BEG_SET + STMT_MID_SET + [TkType.THEN,TkType.ELSIF]

  def initialize(scanner)
    super
  end
  
  def parse(token)
  
    expParser = ExpressionParser.new(self)
    blcParser = BlockParser.new(self)
   
    node  = ICodeGen.generateNode(ICodeNType.IF)
    token = nextTk
    node.addBranch(expParser.parse(token))
    skipEol
    token = sync(IF_SYNC_SET)
    
    if token.getType == TkType.THEN then
      token = nextTk
    else
      @errHandler.flag(token,ErrCode.MISSING_THEN,self)
    end
    
    skipEol
    node.addBranch(blcParser.parse(token))
    
    skipEol
    token = sync(IF_SYNC_SET)
    case token.getType
      when TkType.ELSE
        nextTk
        skipEol
        token = currentTk
        node.addBranch(blcParser.parse(token))
      when TkType.ELSIF
        ifParser = IfParser.new(self)
        node.addBranch(ifParser.parse(token))
      when TkType.SEMICOLON, TkType.EOL
        nextTk
      else
        @errHandler.flag(token,ErrCode.MISSING_EOL,self) if STMT_BEG_SET.include? token.getType
    end

    return node
    
  end

end









