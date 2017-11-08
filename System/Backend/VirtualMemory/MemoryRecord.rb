#! /usr/bin/env ruby

class MemoryRecord < Hash

  def set(varName,value)
    self[varName] = value
  end
  
  def get(varName)
    return nil unless self.keys.include? varName
    self[varName]
  end

end
