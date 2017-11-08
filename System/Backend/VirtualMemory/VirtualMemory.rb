#! /usr/bin/env ruby

class VirtualMemory < MessageGenerator

  def initialize
    @global     = MemoryRecord.new
    @stack      = MemoryStack.new
  end

  def gmalloc(name,value)
    @global.set(name,value)
  end
  
  def lmalloc(name,value)
    @stack.set(name,value)
  end
  
  def gGet(name)
    @global.get(name)
  end
  
  def lGet(name)
    @stack.get(name)
  end
  
  def push(callName)
    @stack.push(callName)
  end
  
  def pop
    @stack.pop
  end

end
