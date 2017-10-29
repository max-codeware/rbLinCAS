#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
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
