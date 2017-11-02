#! /usr/bin/env ruby

##
# This is an implementation of a symbol table entry for LinCAS.
# It collects datas on the entered identifier, and works like a symbol
# table for all the identifier related to that one. A graphical
# representation can be:
# ```
# ENTRY:
#   |- NAME
#   |- DEFINITION
#   |- PATH
#   |- LEVEL
#   |- ATTRIBUTES
#   |__
#      |- SYMBOL_TABLE
# ```
# NAME is the name of the identifier, DEFINITION is the kind of identifier and can be:
# * VOID
# * CLASS
# * MODULE
# * GLOBAL_IDENT
# * LOCAL_IDENT
# * CONST
#
# PATH is the path of the ID in the symbol table, LEVEL is the nesting level,
# while ATTRIBUTES is other information related to the ID.
#
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class SymbolTabEntry < Hash

  # Instantiates the global variables
  def initialize(name,path,level = 0)
    @name    = name
    @path    = path.clone
    @level   = level
    @def     = nil
    @lineNum = []
    @attrs   = {}
  end
  
  # Sets the definition of the entry
  #
  # * **argument**: definition of the ID
  def setDef(definition)
    @def = definition
  end
  
  # Sets an attribute to the entry
  #
  # * **argument**: SymbolTabKey of the attribute
  # * **argument**: attribute
  def setAttr(key,attribute)
    @attrs[key] = attribute
  end
  
  # Adds a line number
  #
  # * **argument**: line number (Integer)
  def addLineNum(lineNum)
    @lineNum << lineNum
  end
  
  # * **returns**: name of the entry
  def getName
    @name
  end
  
  # * **returns**: path of this entry in the SymbolTable
  def getPath
    @path
  end
  
  # * **returns**: the nesting level of the entry
  def getLevel
    @level
  end
  
  # * **returns**: the definition of the entry
  def getDef
    @def
  end
  
  # * **returns**: an attribute of the entry
  def getAttr(key)
    return @attrs[key] if @attrs.keys.include? key
    nil
  end
  
  # * **returns**: all the attrs
  def getAttrs
    @attrs
  end
  
  # * **returns**: the line number of the symbol
  def getLineNums
    @lineNum
  end
  
  # Enters a symbol locally
  #
  # * **argument**: ID name
  # * **returns**: SymbolTabEntry
  def enterLocal(name)
    path = @path.clone
    path.addName(name)
    self[name] = SymTabGen.generateEntry(name,path,@level + 1)
    self[name]
  end
  
  # Looks a symbol up locally
  #
  # * **argument**: name of the symbol (symbol itself)
  # * **returns**: SymbolTabEntry if the symbol exists; +nil+ else
  def lookUpLocal(name)
    return self[name] if self.keys.include? name
    nil
  end
  
  # Forwards an #enterLocal, unless the path points to the current entry
  # 
  # * **argument**: path to the sub-symbol table
  # * **argument**: name of the symbol
  # * **returns**: SymbolTabEntry
  # * **raises**: RuntimeError if the path does not exist or is empty
  def sendEnterLocal(path,name)
    unless path.empty?
      root = path.getRoot
      if self.keys.include? root
        return self[root].sendEnterLocal(path.getChild,name)
      else
        # Should never get here
         raise RuntimeError, "Unexisting symbol table path '#{path.to_s}'"
      end
    else
      return self.enterLocal(name)
    end
  end
  
  # Forwards an #importToLocal consuming the path
  #
  # * **argument**: path to the scope
  # * **argument**: SymbolTabEntry
  def sendImportToLocal(path,entry)
    raise RuntimeError, "Symbol table is receiving an empty path" if path.empty?
    root = path.getRoot
    raise RuntimeError, "Unexisting symbol table path '#{path.to_s}'" unless @name == root
    if path.hasChild? then
      self[root].senfImportToLocal(path.getChild,entry)
    else
      self[root].importToLocal(entry)
    end
  end
  
  # Imports an entry onto the current scope
  #
  # * **argument**: SymbolTabEntry
  def importToLocal(entry)
    name = entry.getName
    entry = entry.clone
    path = @path.clone
    path.addName(name)
    entry.setPath(path)
    self[name] = entry
  end
  
  # * **returns**: all the global variables (used for classes)
  def getGlobal
    global = []
    self.each_key do |entryName|
      entry = self[entryName]
      global << entry if entry.getDef == Def.G_IDENT
    end
    global
  end
  
  # Gets an entry with the specified symbol table path
  #
  # * **argument**: path to the symbol
  # * **returns**: SymbolTabEntry if the path exists; +nil+ else
  def get(path)
    unless path.empty?
      root = path.getRoot
      if path.hasChild? then
        return self[root].get(path.getChild) if self.keys.include? root
      else
        return self[root] if self.keys.include? root
      end
    end
    nil
  end
  
protected

  def setPath(path)
    @path = path.clone
  end
  
end
