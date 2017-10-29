#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
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
