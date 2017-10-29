#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SpecialCharsToken < Token

  def initialize(source)
    super
  end
  
  def extract
    @text = currentChar
    case currentChar
      when ".", "!", ";", ",", "(", ")", "[", "]", "{", "}", "$", "\"", "'"
        nextChar
      when ":", "=", ">", "+", "-", "*", "^", "\\", "/", "%"
        nextChar
        if currentChar == "="
          @text += currentChar
          nextChar
        end
      when "<"
        nextChar
        if currentChar == "=" or currentChar == ">" or currentChar == "<"
          @text += currentChar
          nextChar
        end
      when "|"
        nextChar
        if currentChar == "|"
          @text += currentChar
          nextChar
        end
      when "&"
        nextChar
        if currentChar == "&"
          @text += currentChar
          nextChar
        end
      else 
        @type = TkType.ERROR
        @value = ErrCode.ILLEGAL_EXPR
    end
    @type = TkType.getTypeOf(@text) unless @type
  end

end







