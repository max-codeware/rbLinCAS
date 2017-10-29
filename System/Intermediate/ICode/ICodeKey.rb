#! /usr/bin/env ruby

class ICodeKey < Enum

  enum_attr :LINE
  enum_attr :ID
  enum_attr :VALUE
  enum_attr :OWNER_NAME
  
end

ICKey = ICodeKey.new
