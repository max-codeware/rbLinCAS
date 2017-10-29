#! /usr/bin/env ruby

class SymbolTab < Hash

  def initialize(nLevel)
    @nLevel = nLevel
  end
  
  def getNLevel
    @nLevel
  end
  
  def enter(name)
    entry = SymbolTabGen.generateSymbolTabEntry(name,self)
    self[name] = entry
    return entry
  end
  
  def lookUp(name)
    return self[name] if self.keys.include? name
    nil
  end
  
  def sortedEntries
    keys     = self.keys.sort
    sEntries = []
    keys.each do |key|
      sEntries << self[key]
    end
    return sEntries
  end


end
