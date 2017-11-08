#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class TokenTypeEnum < Enum

 private
  
  # Math functions
  enum_attr :LOG,  "log"
  enum_attr :EXP,  "exp"
  enum_attr :TAN,  "tan"
  enum_attr :ATAN, "atan"
  enum_attr :COS,  "cos"
  enum_attr :ACOS, "acos"
  enum_attr :SIN,  "sin"
  enum_attr :ASIN, "asin"
  enum_attr :SQRT, "sqrt"
  
  # Math constants
  enum_attr :INF,  "inf"
  enum_attr :NINF, "ninf"
  enum_attr :E,    "e"
  enum_attr :PI,   "pi"
  
  # Keywords
  enum_attr :IF,        "if"
  enum_attr :ELSIF,     "elsif"
  enum_attr :THEN,      "then"
  enum_attr :ELSE,      "else"
  enum_attr :VOID,      "void"
  enum_attr :AHEAD,     "ahead"
  enum_attr :SELECT,    "select"
  enum_attr :CASE,      "case"
  enum_attr :AS,        "as"
  enum_attr :WHILE,     "while"
  enum_attr :UNTIL,     "until"
  enum_attr :DO,        "do"
  enum_attr :FOR,       "for"
  enum_attr :FOREACH,   "foreach"
  enum_attr :IN,        "in"
  enum_attr :FROM,      "from"
  enum_attr :TO,        "to"
  enum_attr :DOWNTO,    "downto"
  enum_attr :CLASS,     "class"
  enum_attr :MODULE,    "module"
  enum_attr :PUBLIC,    "public"
  enum_attr :PROTECTED, "protected"
  enum_attr :PRIVATE,   "private"
  enum_attr :INHERITS,  "inherits"
  enum_attr :CONST,     "const"
  enum_attr :LOCKED,    "locked"
  enum_attr :NEW,       "new"
  
  # Internal values
  enum_attr :TRUE,  "true"
  enum_attr :FALSE, "false"
  enum_attr :NULL,  "null"
  
  # Internal methods
  enum_attr :PRINT, "print"
  enum_attr :PRINTL,"printl"
  enum_attr :RETURN,"return"
  enum_attr :READS, "reads"
  
  # Special chars
  enum_attr :DOT,        "."
  enum_attr :MINUS,      "-"
  enum_attr :PLUS,       "+"
  enum_attr :STAR,       "*"
  enum_attr :SLASH,      "/"
  enum_attr :BSLASH,     "\\"
  enum_attr :POWER,      "^"
  enum_attr :GREATER,    ">"
  enum_attr :SMALLER,    "<"
  enum_attr :GREATER_EQ, ">="
  enum_attr :SMALLER_EQ, "<="
  enum_attr :NOT_EQ,     "<>"
  enum_attr :EQ_EQ,      "=="
  enum_attr :EQ,         "="
  enum_attr :MOD,        "%"
  enum_attr :NOT,        "!"
  enum_attr :ADD,        "&"
  enum_attr :AND,        "&&"
  enum_attr :ABS,        "|"
  enum_attr :OR,         "||"
  enum_attr :COLON,      ":"
  enum_attr :SEMICOLON,  ";"
  enum_attr :COMMA,      ","
  enum_attr :COLON_EQ,   ":="
  enum_attr :APPEND,     "<<"
  enum_attr :L_PAR,      "("
  enum_attr :R_PAR,      ")"
  enum_attr :L_BRACE,    "{"
  enum_attr :R_BRACE,    "}"
  enum_attr :L_BRACKET,  "["
  enum_attr :R_BRACKET,  "]"
  enum_attr :PLUS_EQ,    "+="
  enum_attr :MINUS_EQ,   "-="
  enum_attr :STAR_EQ,    "*="
  enum_attr :SLASH_EQ,   "/="
  enum_attr :BSLASH_EQ,  "\\="
  enum_attr :MOD_EQ,     "%="
  enum_attr :POWER_EQ,   "^="
  enum_attr :QUOTES,     "\""
  enum_attr :S_QUOTE,    "'"
  enum_attr :DOLLAR,     "$"
  
end

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class TokenType < Enum
  
  private
  
    # General types
    enum_attr :INT
    enum_attr :FLOAT
    enum_attr :L_IDENT
    # enum_attr :VAR
    enum_attr :STRING
    enum_attr :G_IDENT
    enum_attr :EOL
    enum_attr :EOF
    enum_attr :ERROR
    enum_attr :NAME
  
    EnumHash = {}

   
    tkTypeEnum = TokenTypeEnum.new
    TokenTypeEnum.public_instance_methods(false).each do |method|
      umethod = TokenTypeEnum.public_instance_method(method)
      umethod = umethod.bind(tkTypeEnum)
      out = umethod.call    
      EnumHash[out] = method if out != method
      enum_attr method
    end
    tkTypeEnum = nil
    
 public
 
   def getTypeOf(tkString)
     return EnumHash[tkString.downcase] if self.include? tkString
     return nil
   end
   
   def include?(tkString)
     EnumHash.keys.include? tkString.downcase
   end
  
  
end

TkType = TokenType.new















