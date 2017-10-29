#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class StringToken < Token
  
  def initialize(source)
    super
  end
  
  def extract
    @value = ""
    nextChar
    while currentChar != "\"" and currentChar != EOF
      @value += currentChar
      nextChar
    end
    if currentChar == "\""
      nextChar
      @type = TkType.STRING
    elsif currentChar == EOF
      @type  = TkType.ERROR
      @text  = @value.chomp
      @value = ErrCode.UNEXPECTED_EOF 
    end
    
  end
  
end
