#! /usr/bin/env ruby

##
# This is an implementation of a symbol table for LinCas;
# It is based on the idea of a directory structure: the symbol table
# is the root of the 'system' (and global scope), and all the entries 
# can be seen as files and/or folders (or sub scopes). An example follows
# ```
#        |--- IDENTIFIER(MyVar)
#        |                       |--- GLOBAL_IDENT(@MyAttribute)
# symTab-|--- CLASS(MyClass)-----|--- VOID(MyMethod)
#        |
#        |--- MODULE(MyModule)---|--- VOID(ModuleMethod1)
#                                |--- VOID(ModuleMethod2)
#                                |--- CLASS(ModuleClass)---| ...
#                                                          | ...
#
# ```
# Each level is a scope (or collection of scopes) which is a global scope
# for the upper levels connected to it. Global scopes for global identifiers are
# classes or modules they belong to (or the global scope if they're not nested in
# in one of them).
# The symbol table has a path which points to the last entered symbol or scope
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymbolTable < Hash
  
  # Instantiates the global variables
  def initialize
    @currentPath = SymTabPath.new
    @root        = nil 
    @level       = -1
  end
  
  # Enters a name in the current symbol table the path points at
  #
  # * **argument**: name to enter
  # * **returns**: SymbolTabEntry
  def enterLocal(name)
    unless @currentPath.empty?
      if @currentPath.hasChild?
        toReturn = self[@root].sendEnterLocal(@currentPath.getChild,name)
      else
        toReturn = self[@root].enterLocal(name)
      end
      addNameToPath(name)
    else
      addNameToPath(name)
      toReturn = self[name] = SymTabGen.generateEntry(name,@currentPath,@level + 1)
    end
    toReturn
  end
  
  # Enters a name in the nearest global scope (eg. of a class)
  #
  # * **argument**: name to enter
  # * **returns**: SymbolTabEntry
  def enterGlobal(name)
    path = findGlobalPath
    if path.empty?
      path.addName(name)
      return self[name] = SymTabGen.generateEntry(name,path,@level + 1)
    elsif path.hasChild?
      root = path.getRoot
      raise RunTimeError, "Unexisting symbol table path '#{path.to_s}'" unless @root == root
      return self[root].sendEnterLocal(path.getChild,name)
    else
      root = path.getRoot
      raise RunTimeError, "Unexisting symbol table path '#{path.to_s}'" unless @root == root
      return self[root].enterLocal(name)
    end
  end
  
  # Looks a name up in the current level the path points at
  #
  # * **argument**: name to be looked up
  # * **returns**: SymbolTabEntry if the name exists; +nil+ else
  def lookUpLocal(name)
    if @currentPath.empty? then
      return nil unless self.keys.include? name
      return self[name]
    else
      entry = get(@currentPath)
      raise RunTimeError, "Unexisting symbol table path '#{path.to_s}'" unless entry
      return entry.lookUpLocal(name)
    end
  end
  
  # Looks a name up in the nearest global scope (eg. of a class)
  #
  # * **argument**: name to be looked up
  # * **returns**: SymbolTabEntry if the name exists; +nil+ else
  def lookUpGlobal(name)
    path = findGlobalPath
    if path.empty?
      return nil unless self.keys.include? name
      return self[name]
    else
      entry = get(path)
      raise RunTimeError, "Unexisting symbol table path '#{path.to_s}'" unless entry
      return entry.lookUpLocal(name)
    end
  end
  
  # It goes backward through the path looking the specified name up
  #
  # * **argument**: name to be looked up
  # * **returns**: SymbolTabEntry if the name is found; +nil+ else
  def lookUp(name)
    if @currentPath.empty? then
      return nil unless self.keys.include? name
      return self[name]
    else
      entry = nil
      path  = @currentPath.clone
      while !(path.empty?)
        cEntry = get(path)
        entry  = cEntry.lookUpLocal(name)
        return entry if entry
        path.exitName
      end
    end
    nil
  end
  
  # This is a special lookUp to find a void name; it goes backward
  # until the first global scope (on which it stops) looking the name up
  # and checking its definition.
  #
  # * **argument**: name to be looked up
  # * **returns**: SymbolTabEntry if the void name is found; +nil+ else
  def lookUpVoid(name)
    path       = @currentPath.clone
    globalPath = findGlobalPath
    if ! path.empty? then
      cEntry = get(path)
      entry = checkEntry(cEntry.lookUpLocal(name))
      return entry if entry
      while path != globalPath
        path.exitName
        cEntry = get(path)
        entry = checkEntry(cEntry.lookUpLocal(name))
        return entry if entry
      end
    else
      entry = lookUpLocal(name)
      entry = checkEntry(entry)
      return entry if entry
    end
    nil
  end
  
  # Gets the entry of the specified path
  #
  # * **argument**: path to the entry
  # * **returns**: SymbolTabEntry if the path exists; +nil+ else
  def get(path)
    unless path.empty?
      root = path.getRoot
      return nil unless self.keys.include? root
      if path.hasChild? then
        return self[root].get(path.getChild)
      else
        return self[root]
      end
    end
    nil
  end
  
  # Exits the current level the path's pointing at
  def exitLocal
    @currentPath.exitName
    @root = nil if @currentPath.empty?
  end
  
private

  # Adds a name to the path which must point to it
  def addNameToPath(name)
    @root = name if @currentPath.empty?
    @currentPath.addName(name)
  end
  
  # Finds the nearest global scope (eg. of a class) walking backward
  # on the path
  def findGlobalPath
    terminate  = [Def.CLASS,Def.MODULE]
    path       = @currentPath.clone
    entry      = get(path)
    definition = entry.getDef unless path.empty?
    while !(path.empty?) and !(terminate.include? definition)
      path.exitName
      entry      = get(path)
      definition = entry.getDef
    end   
    path
  end
  
  # Checks if an entry is a void definition
  #
  # * **argument**: SymbolTabEntry
  # * **returns**: SymbolTabEntry if the entry definition is VOID; +nil+ else
  def checkEntry(entry)
    if entry then
      if entry.getDef == :VOID
        return entry
      end
    end
    nil
  end

end








