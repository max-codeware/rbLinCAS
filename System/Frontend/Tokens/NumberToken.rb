#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class NumberToken < Token

  def initialize(source)
    super
  end
  
  def extract
    @text = currentChar
    nextChar
    takeNums
    if currentChar == '.'
      @text += currentChar
      nextChar
      if not currentChar =~ /[0-9]/
        @type  = TkType.ERROR
        @value = ErrCode.INVALID_REAL
      else
        takeNums
        @value = @text.to_f
        @type = TkType.FLOAT
      end
    else
      @value = @text.to_i
    end
    @type = TkType.INT unless @type
  end
  
 private
 
   def takeNums
     while currentChar =~ /[0-9]/
       @text += currentChar
       nextChar
     end
   end

end
