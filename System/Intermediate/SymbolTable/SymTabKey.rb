#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymbolTabKey < Enum
  enum_attr :TYPE
  enum_attr :VOID_STATE
  enum_attr :VOID_TYPE
  enum_attr :ICODE
  enum_attr :PARENT
  enum_attr :VOID_ARGS
  enum_attr :ACCESS
end

SymTabKey = SymbolTabKey.new
