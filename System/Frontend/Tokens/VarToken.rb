#! /usr/bin/env ruby

class VarToken < Token

  def initialize(source)
     super
  end
  
  def extract
    @text = ""
    while currentChar =~ /[a-zA-Z0-9_]/
      @text += currentChar
      nextChar
    end
    type  = TkType.getTypeOf(@value)
    @type = type if type
    @type = TkType.VAR unless type
  end

end
