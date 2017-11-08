#! /usr/bin/env ruby

class MemoryStack < MessageGenerator

  MAX_COUNT = 1000

  def initialize
    @stack      = []
    @callStack  = []
    @count      = -1
  end
  
  def canPush?
    @count < MAX_COUNT
  end
  
  def push(callName)
    @count += 1
    @callStack.push(callName)
    @stack.push MemoryRecord.new
  end
  
  def pop
    @stack.pop
    @callStack.pop
    @count -= 1
  end
  
  def set(varName,value)
    @stack[@count].set(varName,value)
  end
  
  def get(varName)
    @stack[@count].get(varName)
  end
  
  def messageHandler
    @msgHandler
  end

end
