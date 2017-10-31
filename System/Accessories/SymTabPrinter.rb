#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymTabPrinter

  ATTR_FORMAT = ["%sDefinition: %s",
                 "%sNesting level: %i",
                 "%sLineNumbers: %s",
                 "%sAttributes:\n%s"]

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
    puts "-#{path}"
    defs  = [entry.getDef,
             entry.getLevel,
             entry.getLineNums.join(", "),
             attrsToString(entry.getAttrs)]
    for i in 0...defs.size do
      puts ATTR_FORMAT[i] % [@indent, defs[i]]
    end
    puts
    @indent = indentBackUp
    entry.each_key do |key|
      printEntry(entry[key])
    end
  end

private
  
  def attrsToString(attrs)
    s_attr = ""
    indentBackUp = @indent
    @indent += @toIndent
    icodePrinter = ICodePrinter.new(@indent.size)
    icodePrinter.disableHeader
    attrs.each_key do |key|
      s_attr << "#{@indent}#{key} -> #{attrs[key]}\n" unless [:ICODE,:VOID_ARGS].include? key
      if key == :ICODE then
        puts "#{indentBackUp}ICODE:"
        icodePrinter.printICode(attrs[key])
      elsif key == :VOID_ARGS
        s_attr << "#{@indent}#{key}\n#{voidArgsTo_s(attrs[key])}"
      end
    end
    @indent = indentBackUp
    s_attr
  end
  
  def voidArgsTo_s(void_args)
    indentBackUp = @indent
    @indent += @toIndent
    va = ""
    void_args.each do |arg|
      va << "#{@indent}#{arg.getAttr(:ID_PATH).to_s}\n"
    end
    @indent = indentBackUp
    va
  end

end







