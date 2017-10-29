#! /usr/bin/env ruby

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

