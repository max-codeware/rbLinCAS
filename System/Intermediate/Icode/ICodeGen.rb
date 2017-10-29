#! /usr/bin/env ruby

class ICodeGenerator

  def generateNode(type)
    return ICodeNode.new(type)
  end
  
  def generateICode
    return ICode.new
  end

end

ICodeGen = ICodeGenerator.new
