#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class VoidType < Enum
  enum_attr :PUBLIC
  enum_attr :PROTECTED
  enum_attr :PRIVATE
end

VType = VoidType.new
