#! /usr/bin/env ruby

class SymbolTabEntry < Hash

  def initialize(name,symbolTable)
    @name        = name
    @symbolTable = symbolTable
    @lineNums    = []
  end
  
  def getName
    @name
  end
  
  def getSymbolTab
    @symbolTable
  end
  
  def addLineNum(lineNum)
    @lineNums << lineNum
  end
  
  def getLineNums
    @lineNums
  end
  
  def setAttr(symbolTabKey,value)
    self[symbolTabKey] = value
  end
  
  def setDef(definition)
    @def = definition
  end
  
  def getDef
    @def
  end
  
  def getAttr(symbolTabKey)
    return self[symbolTabKey] if self.keys.include? symbolTabKey
    nil
  end

end




