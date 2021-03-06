#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class BlockParser < TDparser

  def initialize(scanner)
    super
  end
  
  def parse(token)
    node   = ICodeGen.generateNode(ICodeNType.BLOCK)
    token  = sync(STMT_BEG_SET)
    tkType = token.getType
    if tkType != TkType.L_BRACE then
      @errHandler.flag(token,ErrCode.MISSING_L_BRACE,self)
    else
      nextTk
      skipEol
      token = currentTk
      tkType = token.getType
    end
    
    stmtParser = StatementParser.new(self)
    
    while tkType != TkType.R_BRACE and !(token.is_a? EofToken)
      node.addBranch(stmtParser.parse(token))
      checkEol(currentTk)
      token  = currentTk
      tkType = token.getType
    end
    
    if tkType == TkType.EOF then
      @errHandler.flag(token,ErrCode.UNEXPECTED_EOF,self)
      @errHandler.abort
    elsif tkType != TkType.R_BRACE
      @errHandler.flag(token,ErrCode.MISSING_R_BRACE,self)
    else
      nextTk
    end

    return node
    
  end

end
