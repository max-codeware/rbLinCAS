#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
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
