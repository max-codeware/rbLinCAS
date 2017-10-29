#! /usr/bin/env ruby

class ErrorHandler

  MaxErr    = 10
  
  def initialize
    @@errCount = 0 unless defined? @@errCount
  end
  
  def getErrorCount
    @@errCount
  end
  
  def flag(token, errCode, parser)
    parser.sendMsg(Message.new(MsgType.SINTAX_ERROR,[token.getLine,
                                                     token.getPos,
                                                     token.getText,
                                                     errCode]))
    @@errCount += 1
    if @@errCount > MaxErr
      abortSystem(MsgType.TOO_MANY_ERRORS,parser)
    end
  end
  
  def abortSystem(errCode, parser)
    fatalMessage = "FATAL: " + errCode.to_s
    parser.sendMsg(Message.new(MsgType.SINTAX_ERROR,[0,0,"",fatalMessage]))
    exit 0
  end

end
