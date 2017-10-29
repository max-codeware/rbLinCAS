#! /usr/bin/env ruby

class VoidTab < Hash

  def addVoid(voidName)
    unless self.keys.include? voidName
      self[voidName] = VoidTabGen.generateVoidDef
    end
  end
  
  def voidDefined?(voidName)
    return self.keys.include? voidName
  end
  
  def replaceVoid(voidName,newVoid)
    aise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName] = newVoid
  end
  
  def setICodeAt(voidName,iCode)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].setICode(iCode)
  end
  
  def setArgsAt(voidName,args)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].setArgs(args)
  end
  
  def setSymTabAt(voidName,symTab)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].setSymTab(symTab)
  end
  
  def setTagAt(voidName,tag)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].setTag(tag)
  end
  
  def setTypeAt(voidName,type)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].setType(type)
  end
  
  def getICodeOf(voidName)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].getICode
  end
  
  def getArgsOf(voidName)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].getArgs
  end
  
  def getSymTabOf(voidName)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].getSymTab
  end
  
  def getTagOf(voidName)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].getTag
  end
  
  def getTypeOf(voidName)
    raise ArgumentError, "Void '#{voidName}' not found" unless self.keys.include? voidName
    self[voidName].getType
  end
  
  def getVoid(voidName)
    return nil unless self.keys.include? voidName
    return self[voidName]
  end

end
