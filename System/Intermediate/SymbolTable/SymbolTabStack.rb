#! /usr/bin/env ruby

class SymbolTabStack < Array

  alias :_push :push
  alias :_pop  :pop

  def initialize
    @currentNLevel = 0
    self << SymbolTabGen.generateSymbolTab(@currentNLevel)
  end
  
  def getCurrentNLevel
    @currentNLevel
  end
  
  def getLocalSymbolTab
    return self[@currentNLevel]
  end
  
  def push(symbolTab = nil)
    @currentNLevel += 1
    if not symbolTab
      self._push SymbolTabGen.generateSymbolTab(@currentNLevel)
    else
      self._push symbolTab
    end
    self.last
  end
  
  def pop
    @currentNLevel -= 1
    self._pop
  end
  
  def enterLocal(name)
    return self[@currentNLevel].enter(name)
  end
  
  def enterAt(name,nLevel)
    raise ArgumentError, "nLevel < 0" unless nLevel >= 0
    return self[nLevel].enter(name)
  end
  
  def lookUpLocal(name)
    return self[@currentNLevel].lookUp(name)
  end
  
  def lookUp(name,nLevel = nil)
    if nLevel
      entry = self[nLevel].lookUp(name)
    else
      entry = nil
      self.each do |symTab|
        entry = symTab.lookUp(name)
        break if entry
      end
    end
    entry
  end

end






