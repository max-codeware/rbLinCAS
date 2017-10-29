#! /usr/bin/env ruby

class EolToken < Token

  def initialize(source)
    super
  end
  
  def extract
    nextChar
    @type = TkType.EOL
    @text = "\\n"
  end

end
