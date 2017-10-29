#! /usr/bin/env ruby

class VoidBuffPrinter

  def initialize
    @indent   = ""
    @toIndent = "    "
  end

  def printBuff(voidBuff)
    puts "********** VOIDS **********"
    voidBuff.each_key do |name|
      voidBuff[name].each_key do |voidName|
        printVoidSpec(name,voidName,voidBuff.getVoidIn(name,voidName))
      end
    end
  end

private
  
  def printVoidSpec(name,voidName,void)
    puts "Void #{name}:#{voidName}"
    indentBackUp = @indent
    @indent += @toIndent
    printVoidAttr(void)
    @indent = indentBackUp
  end
  
  def printVoidAttr(void)
    puts "#{@indent} Tag:  #{void.getTag}"
    puts "#{@indent} Type: #{void.getType}"
    puts "#{@indent} Args:"
    indentBackUp = @indent
    @indent += @toIndent
    iCodePrinter = ICodePrinter.new(@indent.size)
    iCodePrinter.disableHeader
    args = void.getArgs
    args.each do |arg|
      iCode = ICodeGen.generateICode
      iCode.setRoot(arg)
      iCodePrinter.printICode(iCode)
    end
    @indent = indentBackUp
    puts "#{@indent} ICode:"
    @indent += @toIndent
    iCode        = void.getICode
    iCodePrinter.printICode(iCode) if iCode
    @indent = indentBackUp
  end

end



