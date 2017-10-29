#! /usr/bin/env ruby

class ErrorToken < Token
  
  def initialize(source)
    super
    @type  = TkType.ERROR
    @value = ErrCode.ILLEGAL_EXPR
  end
  
  def extract; 
    @text = currentChar
    nextChar
  end
  
end
