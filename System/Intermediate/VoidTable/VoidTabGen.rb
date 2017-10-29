#! /usr/bin/env ruby

class VoidTabGenerator

  def generateVoidTab
    return VoidTab.new
  end
  
  def generateVoidTabBuffer
    return VoidTabBuffer.new
  end
  
  def generateVoidDef
    return VoidDef.new
  end

end

VoidTabGen = VoidTabGenerator.new
