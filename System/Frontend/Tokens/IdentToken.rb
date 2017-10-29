#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class IdentToken < Token

  def initialize(source)
    super
  end
  
  def extract
  
    if currentChar == "@" and not peekChar =~ /[a-zA-Z_]/
      @type  = TkType.ERROR
      @text  = currentChar
      nextChar
      @value = ErrCode.INVALID_IDENT
    else
      @text = currentChar
      nextChar
      while currentChar =~ /[a-zA-Z0-9_]/
        @text += currentChar
        nextChar  
      end
      case @text[0]
        when "@"
          @type = TkType.G_IDENT
        else
          @type = TkType.getTypeOf @text
          if @text[0] < "a"
            @type = TkType.NAME unless @type
          else
            @type = TkType.L_IDENT unless @type
          end
      end
    end
  end

end
