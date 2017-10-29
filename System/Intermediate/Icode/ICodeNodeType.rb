#! /usr/bin/env ruby

class ICodeNodeType < Enum

  # Program structs
  enum_attr :VOID
  
  # Statements
  enum_attr :COMPOUND
  enum_attr :BLOCK
  enum_attr :ASSIGN
  enum_attr :UNTIL
  enum_attr :WHILE
  enum_attr :CALL
  enum_attr :METHOD_CALL
  enum_attr :INDEX_CALL
  # enum_attr :PARAMS
  enum_attr :IF
  enum_attr :SELECT
  enum_attr :CASE
  enum_attr :C_SETS
  enum_attr :ELSE
  enum_attr :RETURN
  enum_attr :NOTHING
  enum_attr :INDEX
  
  # Relational operators
  enum_attr :EQ # Equal
  enum_attr :NE # Not equal
  enum_attr :GR # Greater
  enum_attr :SM # Smaller
  enum_attr :GE # Greater equal
  enum_attr :SE # Smaller equal
  
  # Add operators
  enum_attr :ADD
  enum_attr :SUB
  enum_attr :INVERT
  
  # Mult. operators
  enum_attr :MULT
  enum_attr :IDIV
  enum_attr :FDIV
  enum_attr :MOD
  
  # Logic operators
  enum_attr :AND
  enum_attr :OR  
  enum_attr :NOT  
  
  # Power operator
  enum_attr :POWER
  
  # Operands
  enum_attr :LVARIABLE
  enum_attr :GVARIABLE
  enum_attr :SVARIABLE
  # enum_attr :ROUTINE
  enum_attr :CONST
  enum_attr :NUM_CONST
  enum_attr :STRING_CONST
  enum_attr :BOOL_CONST
  enum_attr :MATH_FUNCT
  enum_attr :INF
  enum_attr :NINF
  
  # IO
  enum_attr :WRITE
  # enum_attr :READ
  
  # Other stuff
  enum_attr :SYMBOLIC
  enum_attr :ABS 
  enum_attr :MATRIX 
  enum_attr :APPEND
  enum_attr :METHOD_NAME
  enum_attr :ARGS
  enum_attr :NAMESPACE
  enum_attr :NAME

end

ICodeNType = ICodeNodeType.new








