#! /usr/bin/env ruby

class MessageHandler

  def initialize
    @listeners = []
  end
  
  def addListener(listener)
    @listeners << listener
  end
  
  def removeListener(listener)
    @listeners.remove listener
  end
  
  def sendMsg(message)
    @msg = message
    notifyListeners
  end
  
  private
    
    def notifyListeners
      @listeners.each do |listener|
        listener.receiveMsg @msg
      end
    end
  
end
