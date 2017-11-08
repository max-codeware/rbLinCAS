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
    @@symTab
  end
  
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
   
   def enableReturn
     @@return = true
   end
  
   def disableReturn
     @@return = false
   end
  
   def returnEnabled?
     @@return
   end
   
end
