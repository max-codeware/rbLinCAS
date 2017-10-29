#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ICodeKey < Enum

  enum_attr :LINE
  enum_attr :ID
  enum_attr :ID_PATH
  enum_attr :VALUE
  enum_attr :OWNER_NAME
  
end

ICKey = ICodeKey.new
