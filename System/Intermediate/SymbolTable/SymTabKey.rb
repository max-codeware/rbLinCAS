#! /usr/bin/env ruby

class Enum
  private
    def self.enum_attr(name,value = nil)
      define_method(name) do
        return name if value == nil
        return value
      end
    end    
end
##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymbolTabKey < Enum
  enum_attr :TYPE
  enum_attr :VOID_STATE
  enum_attr :ICODE
  enum_attr :PARENT
end
