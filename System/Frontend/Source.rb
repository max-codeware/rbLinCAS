#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Source < MessageGenerator
 
  EOF = 3.chr
  
  def initialize(reader) 
    # @msgListener = SourceListener.new
    @reader     = reader
    @line       = nil
    @lineNum    = 0
    @currentPos = -1  
  end
  
  def getLine
    @lineNum
  end
  
  def getPos
    @currentPos
  end
  
  def currentChar
    if @line == nil and @currentPos != -1
      return EOF
    elsif getPos == -1 or getPos > @line.size - 1
      readLine
      return nextChar
    else
      return @line[@currentPos]
    end 
  end
  
  def nextChar
    @currentPos += 1
    currentChar
  end
  
  def peekChar
    currentChar
    return EOF if @line == nil
    nextPos = @currentPos + 1
    return (nextPos < @line.size - 1) ? @line[nextPos] : "\n"
  end
  
  def close
    @reader.close
  end
  
  def readLine
    @line = @reader.readLine
    @lineNum += 1 if @line != nil
    @currentPos = -1
  end
  
  def messageHandler
    return @msgHandler
  end
  
  # class SourceListener
  #
  #   def receiveMsg(message)
  #     msgType = message.getType
  #     case msgType
  #       when :IO_ERROR
  #        
  #     end
  #   end
  #
  # end
  
  private
    
    def messageHandler=(msgHandler)
      @msgHandler = msgHandler
    end
    
end
