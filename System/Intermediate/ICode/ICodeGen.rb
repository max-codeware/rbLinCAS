#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ICodeGenerator

  def generateNode(type)
    return ICodeNode.new(type)
  end
  
  def generateICode
    return ICode.new
  end

end

ICodeGen = ICodeGenerator.new
