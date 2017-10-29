#! /usr/bin/env ruby

##
# This is an implementation of a symbol table path. It can be seen
# as a collection of pointers to the local symbol/symbol table
# ```
# ->Id1->Id2->Id3...
# ```
# Graphically: ```Id1:Id2:Id3...```
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymTabPath

  # Instantiates the global array
  #
  # * **argument**: initial array of pointers (optional)
  def initialize(path = [])
    @path = path
  end
  
  # Adds a pointer to the queue
  #
  # * **argument**: name to add
  def addName(name)
    @path << name
  end
  
  # * **returns*: root of the path (first pointer)
  def getRoot
    @path[0]
  end
  
  # * **returns**: SymTabPath of the root children
  def getChild
    return SymTabPath.new(@path[1...@path.size]) if @path.size > 0
    SymTabPath.new
  end
  
  # Drops off the last pointer inserted
  def exitName
    @path.pop
  end
  
  # * **returns** +true+ if the path is empty; +false+ else
  def empty?
    @path.size == 0
  end
  
  # * **returns**: +true+ if the root points to other IDs
  def hasChild?
    @path.size > 1
  end
  
  # * **returns**: clone of itself
  def clone
    path = @path.clone
    return SymTabPath.new(path)
  end
  
  # Checks if a path equals to itself
  #
  # * **argument**: path to be checked
  # * **returns**: +true+ in case of match; +false+ else
  def ==(path)
    self.to_s == path.to_s
  end
  
  # * **returns**: string representation of the path
  def to_s
    return "" if self.empty?
    @path.join(":")
  end
  
end
