#! /usr/bin/env ruby

class UntilParser < TDparser

  UNT_SYNC_SET = [TkType.UNTIL,
                  TkType.L_IDENT,
                  TkType.G_IDENT,
                  TkType.NUMBER,
                  TkType.EOL,
                  TkType.SEMICOLON]

  def initialize(source)
    super
  end
  
  def parse(token)
    skipEol
    blcParser = BlockParser.new(self)
    expParser = ExpressionParser.new(self)
    node      = ICodeGen.generateNode(ICodeNType.UNTIL)
    node.addBranch(blcParser.parse(token))
    skipEol
    token  = sync(UNT_SYNC_SET)
    tkType = token.getType
    
    if tkType != TkType.UNTIL then
      @errHandler.flag(token,ErrCode.MISSING_UNTIL,self)
    else
      token = nextTk
    end
    checkEof(token)
    
    test = expParser.parse(token)
    if test
      node.addBranch(test)
    else
      @errHandler.flag(token,ErrCode.MISSING_CONDITION,self)
    end
    
    token  = currentTk
    checkEol(token)
    
    return node
    
  end
  
 private
 
   def checkEof(token)
     tkType = token.getType
     if tkType == TkType.EOF then
       @errHandler.flag(token,ErrCode.UNEXPECTED_EOF,self)
     end
   end

end
