#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class FrontendGenerator
  
  def generateParser(source)
    return TDparser.new(Scanner.new(source))
  end
  
  def generateSource(reader)
    return Source.new(reader)
  end
  
  def generateReader(path)
    return Reader.new(path)
  end
  
end

FendGen = FrontendGenerator.new

