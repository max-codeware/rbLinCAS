#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ErrorToken < Token
  
  def initialize(source)
    super
    @type  = TkType.ERROR
    @value = ErrCode.ILLEGAL_EXPR
  end
  
  def extract; 
    @text = currentChar
    nextChar
  end
  
end
