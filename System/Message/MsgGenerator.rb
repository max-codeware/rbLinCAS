#! /usr/bin/env ruby

class MessageGenerator

  def addMsgListener(listener)
    self.messageHandler.addListener listener
  end
  
  def removeMsgListener(listener)
    self.messageHandler.removeListener listener
  end
  
  def sendMsg(message)
     self.messageHandler.sendMsg message
  end

end
