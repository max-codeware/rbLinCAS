#! /usr/bin/env ruby

class TokenDisplayerParser < TDparser

  def initialize(scanner)
    super
  end
  
  def parse
    while not currentTk.is_a? EofToken
      token  = currentTk
      tkType = token.getType
      if tkType != TkType.ERROR
        sendMsg(Message.new(MsgType.TOKEN,[token.getLine,
                                           token.getPos,
                                           token.getType,
                                           token.getText,
                                           token.getValue]))
        nextTk
      else
        @errHandler.flag(token,token.getValue,self)
      end
    end 
  end

end
