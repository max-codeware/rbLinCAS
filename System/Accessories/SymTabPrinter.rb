#! /usr/bin/env ruby

class SymTabPrinter

  ATTR_FORMAT = ["%sDefinition: %s",
                 "%sNesting level: %i",
                 "%sLineNumbers: %s",
                 "%sAttributes: %s"]

  def initialize
    @indent   = ""
    @toIndent = "    "
  end

  def printTable(symTab)
    puts ("*" * 6) << "SYMBOL TABLE" << ("*" * 6)
    symTab.each_key do |key|
      printEntry(symTab[key])
    end
  end
  

  def printEntry(entry)
    indentBackUp = @indent
    @indent += @toIndent
    path  = entry.getPath
    defs  = [entry.getDef,
             entry.getLevel,
             entry.getLineNums.join(", "),
             attrsToString(entry.getAttrs)]
    puts path
    for i in 0...defs.size do
      puts ATTR_FORMAT[i] % [@indent, defs[i]]
    end
    @indent = indentBackUp
    entry.each_key do |key|
      printEntry(entry[key])
    end
  end

private
  
  def attrsToString(attrs)
    s_attr = ""
    attrs.each_key do |key|
      s_attr << "#{key} -> #{atts[key]}\n"
    end
    s_attr
  end

end







