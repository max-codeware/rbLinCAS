#! /usr/bin/env ruby

class VoidTabBuffer < Hash

  def initialize
    self["Main"] = VoidTabGen.generateVoidTab
    @atTop = "Main"
  end
  
  def atTop(name)
    raise ArgumentError, "Name '#{name}' not found" unless self.keys.include? name
    @atTop = name
  end
  
  def getAtTop
    @atTop
  end
  
  def addName(name)
    unless self.keys.include? name
      self[name] = VoidTabGen.generateVoidTab
    end
  end
  
  def addVoidName(voidName)
    self[@atTop].addVoid(voidName)
  end
  
  def setICodeAt(voidName,iCode)
    self[@atTop].setICodeAt(voidName,iCode)
  end
  
  def setArgsAt(voidName,args)
    self[@atTop].setArgsAt(voidName,args)
  end
  
  def setSymTabAt(voidName,symTab)
    self[@atTop].setSymTabAt(voidName,symTab)
  end
  
  def setTagAt(voidName,tag)
    self[@atTop].setTagAt(voidName,tag)
  end
  
  def setTypeAt(voidName,type)
    self[@atTop].setTypeAt(voidName,type)
  end
  
  def getICodeOf(voidName)
    return self[@atTop].getICodeOf(voidName)
  end
  
  def getArgsOf(voidName)
    return self[@atTop].getArgsOf(voidName)
  end
  
  def getSymTabOf(voidName)
    return self[@atTop].fetSymTabOf(voidName)
  end
  
  def getTagOf(voidName)
    return self[@atTop].fetTagOf(voidName)
  end
  
  def getTypeOf(voidName)
    return self[@atTop].fetTypeOf(voidName)
  end
  
  def definedLocally?(voidName)
    return self[@atTop].voidDefined?(voidName)
  end
  
  def replaceVoid(voidName,newVoid)
    self[@atTop].replaceVoid(voidName,newVoid)
  end
  
  def getVoidIn(name,voidName)
    raise ArgumentError, "Name '#{name}' not found" unless self.keys.include? name
    return self[name].getVoid(voidName)
  end
  
  def getLocalVoid(voidName)
    return self[@atTop].getVoid(voidName)
  end
  
end




