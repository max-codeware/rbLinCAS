#! /usr/bin/env ruby

class Token
  
  EOF = 3.chr
  
  def initialize(source)
    @source   = source
    @lineNum  = @source.getLine
    @position = @source.getPos + 1
    @type     = nil
    @text     = nil
    @value    = nil
    extract
  end
  
  def getLine
    @lineNum
  end
  
  def getPos
    @position
  end
  
  def getType
    @type
  end
  
  def getText
    @text
  end
  
  def getValue
    @value
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
  
end
