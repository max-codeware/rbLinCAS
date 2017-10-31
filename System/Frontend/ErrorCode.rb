#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ErrorCode < Enum
  enum_attr :UNEXPECTED_EOF,   "Unexpected end-of-file"
  enum_attr :UNEXPECTED_EOL,   "Unexpected end-of-line"
  enum_attr :UNEXPECTED_BOOL,  "Unexpected boolean constant in symbolic expression"
  enum_attr :UNEXPECTED_LOGIC_OP, "Unexpected logic operator in symbolic expression"
  enum_attr :UNEXPECTED_TK,    "Unexpected token"
  enum_attr :UNEXPECTED_INF,   "Unexpected infinity constant in non-symbolic expression"
  enum_attr :INVALID_IDENT,    "Invalid identifier"
  enum_attr :INVALID_VAR,      "Invalid variable"
  enum_attr :INVALID_REAL,     "Invalid real format"
  enum_attr :INVALID_CALL_NAME,"invalid method name"
  enum_attr :ILLEGAL_EXPR,     "Illegal expression"
  enum_attr :UNDEF_IDENT,      "Undefined identifier"
  enum_attr :UNDEF_VOID,       "Undefined void"
  enum_attr :MISSING_R_PAR,    "Missing ')'"
  enum_attr :MISSING_L_PAR,    "Missing '('"
  enum_attr :MISSING_L_BRACE,  "Missing '{'"
  enum_attr :MISSING_R_BRACE,  "Missing '}'"
  enum_attr :MISSING_END_ABS,  "Missing end abs"
  enum_attr :MISSING_ID,       "Invalid or missing identifier"
  enum_attr :MISSING_ID_ASSIGN,"Invalid or missing identifier for assign statement"
  enum_attr :MISSING_COLON_EQ, "Missing ':=' in assign statement"
  enum_attr :MISSING_L_BRACKET,"Missing ']'"
  enum_attr :MISSING_R_BRACKET,"Missing '['"
  enum_attr :MISSING_EOL,      "Missing end-of-line or ';'"
  enum_attr :MISSING_THEN,     "Missing keyword 'then'"
  enum_attr :MISSING_UNTIL,    "Missing keyword 'until'"
  enum_attr :MISSING_CONDITION,"Missing condition"
  enum_attr :MISSING_COLON,    "Missing ':'"
  enum_attr :MISSING_TO_DWTO,  "Missing 'to' or 'downto'"
  enum_attr :MISSING_CS_ES,    "Missing keyword 'case' or 'else'"
  enum_attr :MISSING_DOT,      "Missing '.'"
  enum_attr :MISSING_ARG,      "Missing argument"
  enum_attr :MISSING_NAME,     "Missing name"
  enum_attr :MAYBE_MISS_INDEX, "Maybe missing index"
  enum_attr :ALREADY_FORWARDED,"Void already forwarded"
  enum_attr :ID_DEFINED,       "Identifier already defined. It's definition won't change"
  enum_attr :VOID_DEFINED,     "Void already defined"
  enum_attr :CANNOT_CHANGE_INT,"Void already defined as internal. It won't be redefined"
  enum_attr :IRREGULAR_MATRIX, "Irregular matrix rows"
end

ErrCode = ErrorCode.new
