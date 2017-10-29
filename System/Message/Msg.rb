#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Message
  
  def initialize(type,body)
    @Type = type
    @body = body
  end
    
  def getType
    return @Type
  end
  
  def getBody
    return @body
  end
    
end
