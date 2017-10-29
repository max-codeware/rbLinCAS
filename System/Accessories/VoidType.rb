#! /usr/bin/env ruby

class VoidType < Enum
  enum_attr :PUBLIC
  enum_attr :PROTECTED
  enum_attr :PRIVATE
end

VType = VoidType.new
