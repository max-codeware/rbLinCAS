#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Parser < MessageGenerator

  def initialize(scanner)
    if scanner.is_a? Scanner
      @scanner    = scanner
    elsif scanner.is_a? Parser
      @scanner = scanner.getScanner
    else
      raise ArgumentError, "Expecting scanner or parser but #{scanner.class} found"
    end
    @@msgHandler = MessageHandler.new              unless defined? @@msgHandler
    @@return    = false                            unless defined? @@return
#    @@state     = [ParsingSt.MAIN]                 unless defined? @@state
#    @@voidBuff  = VoidTabGen.generateVoidTabBuffer unless defined? @@voidBuff
#    @@name      = ["Main"]                         unless defined? @@name
    @@dummy     = 0                                unless defined? @@dummy
    @@symTab    = SymTabGen.generateSymbolTable    unless defined? @@symTab
    @iCode      = nil
  end
  
  def getScanner
    @scanner
  end
  
  def getICode
    @iCode
  end
  
  def getSymTab
    @symTab
  end
  
  def getSymTabStack
    @@symbolTabStack
  end
  
#  def getVoidBuff
#    @@voidBuff
#  end
  
  def messageHandler
    @@msgHandler
  end
  
  def currentTk
    @scanner.currentTk
  end
  
  def nextTk
    @scanner.nextTk
  end
  
 protected
 
   def pushName(name)
     @@name.push name
   end
   
   def popName
     @@name.pop
   end
   
   def topName
     @@name.last
   end
   
   def enableReturn
     @@return = true
   end
  
   def disableReturn
     @@return = false
   end
  
   def returnEnabled?
     @@return
   end
=begin  
   def pushState(state)
     @@state.push(state)
   end
  
   def popState
     @@state.pop
   end
  
   def getStateAt(level)
     @@state[level]
   end
  
   def getStateLevel
     @@state.size
   end
=end
end
