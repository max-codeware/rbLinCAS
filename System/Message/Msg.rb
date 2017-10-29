#! /usr/bin/env ruby

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
