#! /usr/bin/env ruby

require_relative "System/System.rb"

filepath = File.expand_path("Tests/Test12.txt",File.dirname(__FILE__))
reader = FendGen.generateReader(filepath)
source = FendGen.generateSource(reader)
parser = FendGen.generateParser(source)
# parser = TokenDisplayerParser.new(Scanner.new(source))
class ParserListener

  TkMessageFormat =  "Type: %s, line: %i, position: %i, text: %s, value: %s"
  SummaryMsgFormat = "\n Source lines:       %i\n Sintax errors:      %i\n Total parsing time: %f (ms)"
  SintaxErrorMessage = "\n Sintax error: %s\n Line %i:%i in '%s'"

  def receiveMsg(message)
  
    body = message.getBody
  
    case message.getType
    
      when MsgType.TOKEN
        line = body[0]
        pos  = body[1]
        type = body[2]
        text = body[3]
        value = body[4]
        puts TkMessageFormat % [type,line,pos,text,value.to_s]
      when MsgType.PARSER_SUMMARY
        stmtCount = body[0]
        errCount  = body[1]
        time      = body[2]
        puts SummaryMsgFormat % [stmtCount,errCount,time]
      when MsgType.SINTAX_ERROR
        line = body[0]
        pos  = body[1]
        text = body[2]
        errCode = body[3]
        puts SintaxErrorMessage % [errCode,line,pos,text]
    end
  end

end

parser.addMsgListener(ParserListener.new)
parser.parse
iCode    = parser.getICode
iCodePrinter    = ICodePrinter.new
symTabPrinter   = SymTabPrinter.new
iCodePrinter.printICode(iCode)
symTabPrinter.printTable(parser.getSymTab)
source.close




