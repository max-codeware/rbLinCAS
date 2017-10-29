#! /usr/bin/env ruby

class ICodeNode < Hash

  def initialize(type)
    @type   = type
    @parent = nil
    @nodes  = []
  end
  
  def getType
    @type
  end
  
  def getParent
    @parent
  end
  
  def addBranch(node)
    if node
      @nodes << node
      node.parent = self
    end
    return node
  end
  
  def getBranches
    @nodes
  end
  
  def parent=(node)
    @parent = node
  end
  
  def setAttr(key,value)
    self[key] = value
  end
  
  def getAttr(key)
    return self[key] if self.include? key
    nil
  end
  
  def copy
    cp = ICodeGen.generateNode(@type)
    self.keys.each do |key|
      cp[key] = self[key]
    end
    return cp
  end
  
  def to_s
    return @type.to_s
  end

end
