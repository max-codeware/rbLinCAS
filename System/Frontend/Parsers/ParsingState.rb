#! /usr/bin/env ruby

class ParsingState < Enum

  enum_attr :MAIN
  enum_attr :VOID
  enum_attr :CLASS
  enum_attr :MODULE

end

ParsingSt = ParsingState.new
