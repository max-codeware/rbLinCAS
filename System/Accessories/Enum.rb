#! /usr/bin/env ruby


class Enum
#  @attr = []
  private
    def self.enum_attr(name,value = nil)
      define_method(name) do
        return name if value == nil
        return value
      end
    end    
end

