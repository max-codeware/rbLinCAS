#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class MessageType < Enum
  enum_attr :INTERPRETER_SUMMARY
  enum_attr :PARSER_SUMMARY
  enum_attr :SINTAX_ERROR
  enum_attr :COMMENT_MEETS_EOF_ERROR
  enum_attr :RUNTIME_ERROR
  enum_attr :ARGUMENT_ERROR
  enum_attr :NO_METHOD_ERROR
  enum_attr :INTERNAL_ERROR
  enum_attr :TOKEN
  enum_attr :IO_ERROR
  enum_attr :TOO_MANY_ERRORS
end

MsgType = MessageType.new
