#! /usr/bin/env ruby

class SymTabPrinter
  
  Main = "\n---SYMBOL TAB---\n"
  Name = "%s    "
  Line = "%i "
  
  def printST(symbolTabStack)
    puts Main
    symbolTab = symbolTabStack.getLocalSymbolTab
    sorted = symbolTab.sortedEntries
    sorted.each do |entry|
      lineNum = entry.getLineNums
      print Name % entry.getName
      if lineNum
        lineNum.each do |ln|
          print Line % ln
        end
      end
      puts
    end
  end

end
