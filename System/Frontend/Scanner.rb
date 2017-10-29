#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Scanner < MessageGenerator
  
  EOF = 3.chr
  
  def initialize(source)
    @msgHandler = MessageHandler.new
    @msgHandler.addListener(ScannerListener.new)
    @source    = source
    @currentTk = nextTk
  end
  
  def currentTk
    @currentTk
  end
  
  def nextTk
    @currentTk = extractTk
    @currentTk
  end
  
  def messageHandler
    @msgHandler
  end
  
  protected
  
    def currentChar
      @source.currentChar
    end
  
    def nextChar
      @source.nextChar
    end
  
    def peekChar
      @source.peekChar
    end
    
    def extractTk
  
      skipWhiteSpaces

      case currentChar
        # when /[a-zA-Z_]/
        #  return VarToken.new(@source)
        when /[\r\n]/
          return EolToken.new(@source)
        when /[@a-zA-Z_]/
          return IdentToken.new(@source)
        when /[0-9]/
          return NumberToken.new(@source)
        when 3.chr
          return EofToken.new(@source)
        when "\""
          return StringToken.new(@source)
      end
      return SpecialCharsToken.new(@source) if TkType.include? currentChar
      return ErrorToken.new(@source)
    end
  
    def skipWhiteSpaces
      while (currentChar == " " or currentChar == "\t") and currentChar != EOF
        nextChar
      end
      if currentChar == "/" and peekChar == "*"
        nextChar
        loop do
          break if currentChar == "*" and peekChar == "/"
          break if currentChar == EOF
          nextChar
        end 
        nextChar
        if currentChar == '/'
          nextChar
        elsif currentChar == EOF
          sendMsg Message.new(MsgType.COMMENT_MEETS_EOF_ERROR,["Comment meets end-of-file",@source.getLine])
        end
      end
    end
  
  private
  
    class ScannerListener
      
      SINTAX_ERROR_FORMAT = "%s: %s; line %i"
      
      def receiveMsg(message)
        msgType = message.getType
        if msgType == :COMMENT_MEETS_EOF_ERROR
          body = message.getBody
          puts SINTAX_ERROR_FORMAT % [msgType.to_s,body[0],body[1]]
          exit 0
        end
      end
      
    end
  
end
