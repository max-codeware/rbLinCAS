#! /usr/bin/env ruby

##
# It's a small interface to generate symbol tables ans symbol
# table entries
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymbolTabGenerator

  def generateSymbolTable
    return SymbolTable.new
  end
  
  def generateEntry(name,path,level)
    return SymbolTabEntry.new(name,path,level)
  end

end
SymTabGen = SymbolTabGenerator.new
