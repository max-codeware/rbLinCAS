#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Reader < MessageGenerator

  def initialize(filename)
    @msgListener = ReaderListener.new
    @msgHandler = MessageHandler.new
    addMsgListener @msgListener
    if not File.file? filename
      body = ["Invalid directory '#{filename}'"]
      sendMsg Message.new(MsgType.IO_ERROR,body)
    end
    begin
      @file = File.open(filename,'r')
    rescue => err
      body = ["Cannot open file\n#{err}"]
      sendMsg Message.new(MsgType.IO_ERROR,body)
    end
  end
  
  def readLine
    @file.gets
  end
  
  def close
    @file.close
  end
  
  def messageHandler
    @msgHandler
  end
  
  
  private
    
    ##
    #
    # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
    # License:: Distributed under MIT license
    class ReaderListener
    
      IO_ERROR_FORMAT = "%s: %s"
      
      def receiveMsg(message)
        msgType = message.getType
        case msgType
          when :IO_ERROR
            msgBody = message.getBody
            puts IO_ERROR_FORMAT % [msgType.to_s,msgBody[0]]
            exit 0
        end
      end
      
    end

end



