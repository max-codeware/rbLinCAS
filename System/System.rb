#! /usr/bin/env ruby

module System

  module Accessory
    %w|Accessories/Enum.rb Accessories/SymTabPrinter.rb
       Accessories/ICodePrinter.rb Accessories/VoidBuffPrinter.rb
       Accessories/Type.rb Accessories/VoidType.rb|.each do |file|
    
      require_relative File.expand_path(file,File.dirname(__FILE__))
      
    end
  end

  module Message
    include System::Accessory
    %w|Message/Msg.rb Message/MsgGenerator.rb 
       Message/MsgHandler.rb Message/MsgType.rb|.each do |file|
       
         require_relative File.expand_path(file,File.dirname(__FILE__))
      
       end
  end
  
  module Intermediate
    include System::Accessory
    %w|Intermediate/SymbolTable/SymbolTabKey.rb
       Intermediate/SymbolTable/SymbolTabStack.rb
       Intermediate/SymbolTable/SymbolTab.rb
       Intermediate/SymbolTable/SymbolTabEntry.rb
       Intermediate/SymbolTable/SymbolTabGen.rb
       Intermediate/Icode/ICodeKey.rb Intermediate/Icode/ICodeNode.rb
       Intermediate/Icode/ICodeNodeType.rb Intermediate/Icode/ICode.rb
       Intermediate/Icode/ICodeGen.rb Intermediate/VoidTable/VoidDef.rb
       Intermediate/VoidTable/VoidTable.rb Intermediate/VoidTable/VoidTableBuffer.rb
       Intermediate/VoidTable/VoidTabGen.rb|.each do |file|
       
         require_relative File.expand_path(file,File.dirname(__FILE__))
         
       end
  end
  
  module Frontend
    include System::Message
    include System::Intermediate
    %w|Frontend/Reader.rb Frontend/Source Frontend/ErrorCode.rb
       Frontend/Tokens/Token.rb Frontend/Tokens/TokenType.rb
       Frontend/Tokens/StringToken.rb
       Frontend/Tokens/IdentToken.rb Frontend/Tokens/VarToken.rb
       Frontend/Tokens/NumberToken.rb Frontend/Tokens/EolToken.rb
       Frontend/Tokens/EofToken.rb Frontend/Tokens/ErrorToken.rb
       Frontend/Tokens/SpecialCharsToken.rb Frontend/ErrorHandler.rb
       Frontend/Scanner.rb Frontend/Parsers/ParserEnums.rb Frontend/Parsers/SyncSets.rb
       Frontend/Parsers/ParsingState.rb 
       Frontend/Parsers/Parser.rb Frontend/Parsers/TDparser.rb
       Frontend/Parsers/StatementParser.rb Frontend/Parsers/ExpressionParser.rb
       Frontend/Parsers/IDparser.rb
       Frontend/Parsers/AssignParser.rb Frontend/Parsers/MatrixParser.rb
       Frontend/Parsers/IfParser.rb Frontend/Parsers/BlockParser.rb
       Frontend/Parsers/UntilParser.rb Frontend/Parsers/WhileParser.rb
       Frontend/Parsers/ForParser.rb Frontend/Parsers/SelectParser.rb
       Frontend/Parsers/VoidParser.rb Frontend/Parsers/TokenDisplayer.rb
       Frontend/FrontendGen.rb|.each do |file|
       
         require_relative File.expand_path(file,File.dirname(__FILE__))
      
       end
  end

end
















