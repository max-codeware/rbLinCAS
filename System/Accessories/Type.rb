#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Type < Enum

  enum_attr :UNDEF
  enum_attr :INT
  enum_attr :FLOAT
  enum_attr :CLASS
  enum_attr :MODULE
  enum_attr :VOID
  enum_attr :STRING
  enum_attr :FUNCT
  enum_attr :VECTOR
  enum_attr :MATRIX

end

Tp = Type.new
