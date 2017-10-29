#! /usr/bin/env ruby

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
      end
    else
      @value = @text.to_i
    end
    @type = TkType.NUMBER unless @type
  end
  
 private
 
   def takeNums
     while currentChar =~ /[0-9]/
       @text += currentChar
       nextChar
     end
   end

end
