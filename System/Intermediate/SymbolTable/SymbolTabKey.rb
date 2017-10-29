#! /usr/bin/env ruby

class SymbolTabKey < Enum

  # Costants
  enum_attr :CONSTANT_VALUE
  
  # Procedures & functions
  enum_attr :ROUTINE_CODE
  # enum_attr :ROUTINE_SYMBOL_TAB
  # enum_attr :ROUTINE_ICODE
  # enum_attr :ROUTINE_PARAMS
  # enum_attr :ROUTINE_ROUTINES
  
  # Variables
  enum_attr :DATA_VALUE
  
  # Parameters
  enum_attr :PARAMETER

end

SymTabKeys = SymbolTabKey.new

