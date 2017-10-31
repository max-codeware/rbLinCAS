#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ICodePrinter

  Width = 80

  def initialize(initialIndent = 0)
    @length      = 0
    @indentation = " " * initialIndent
    @indent      = "    "
    @line        = ""
    @header = true
  end
  
  def printICode(iCode)
    puts "********** ICODE **********" if @header
    printNode(iCode.getRoot)
    printL
  end
  
  def disableHeader
    @header = false
  end
  
  def enableHeader
    @header = true
  end
  
private
  
  def printNode(node)
  
    append(@indentation)
    append("<" + node.to_s)
    
    printAttrs(node)
    printTypeSpec(node)
    
    branches = node.getBranches
    if branches.size > 0 then
    
      append ">"
      printL
      printBranches(branches)
      append(@indentation)
      append("</" + node.to_s + ">")
      
    else
    
      append(" ")
      append("/>")
      
    end
    printL
  end
  
  def printAttrs(node)
  
    oldIndent = @indentation
    @indentation += @indent
    
    node.keys.each { |_attr| printAttr(_attr,node[_attr])}
      
    @indentation = oldIndent

  end
  
  def printAttr(key,value)
    symTabEntry = value.is_a? SymbolTabEntry
    val = symTabEntry ? value.getName : value.to_s
    other = key.to_s + "=\"" + val + "\""
    append(" ")
    append(other)
    
    if symTabEntry
      level = value.getLevel
      printAttr("LEVEL",level)
    end
  end
  
  def printBranches(branches)

    oldIndent = @indentation
    @indentation += @indent

    branches.each do |branch|
      printNode(branch)
    end
    @indentation = oldIndent

  end
  
  def printTypeSpec(node); end
  
  def append(text)

    textSize = text ? text.size : 0
    lBreak = false
    
    if @length + textSize > Width
      printL
      @line += @indentation
      @lenght = @indentation.size
      lBreak = true
    end
    
    if not (lBreak and text == " ")
      @line += text ? text : ""
      @length += textSize
    end
    
  end
  
  def printL
    if @length > 0
      puts @line
      @line = ""
      @length = 0
    end
  end

end












