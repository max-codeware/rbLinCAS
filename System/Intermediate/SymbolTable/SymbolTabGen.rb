#! /usr/bin/env ruby

class SymbolTabGenerator

  def generateSymbolTab(nLevel)
    return SymbolTab.new(nLevel)
  end
  
  def generateSymbolTabEntry(name, symbolTab)
    return SymbolTabEntry.new(name, symbolTab)
  end
  
  def generateSymbolTabStack
    return SymbolTabStack.new
  end


end

SymbolTabGen = SymbolTabGenerator.new
