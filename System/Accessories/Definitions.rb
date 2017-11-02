#! /usr/bin/env ruby


##
# Entry definition enum
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Definition < Enum

 enum_attr :CLASS
 enum_attr :MODULE
 enum_attr :VOID
 enum_attr :L_IDENT
 enum_attr :G_IDENT
 enum_attr :CONST
 enum_attr :AUTOREF

end
Def = Definition.new
