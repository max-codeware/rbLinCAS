#! /usr/bin/env ruby

class EofToken < Token
  
  def initialize(source)
    super
    @type = TkType.EOF
    @text = 3.chr
  end
  
  def extract; end
  
end
