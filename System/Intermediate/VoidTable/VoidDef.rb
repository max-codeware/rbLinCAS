#! /usr/bin/env ruby

class VoidDef

  def initialize
    @args = []
  end

  def setICode(iCode)
    @iCode = iCode
  end
  
  def setArgs(args)
    @args = args
  end
  
  def setSymTab(symTab)
    @symTab = symTab
  end
  
  # Tag can be
  # * AHEAD
  # * DECLARED
  # * INTERNAL
  def setTag(tag)
    @tag = tag
  end
  
  def setType(type)
    @type = type
  end
  
  def getICode
    @iCode
  end
  
  def getArgs
    @args
  end
  
  def getSymTab
    @symTab
  end
  
  def getTag
    @tag
  end
  
  def getType
    @type
  end

end
