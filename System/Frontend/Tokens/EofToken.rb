#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class EofToken < Token
  
  def initialize(source)
    super
    @type = TkType.EOF
    @text = 3.chr
  end
  
  def extract; end
  
end
