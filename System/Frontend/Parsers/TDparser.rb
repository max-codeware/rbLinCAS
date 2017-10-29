#! /usr/bin/env ruby

class TDparser < Parser

  def initialize(scanner)
    super(scanner)
    @errHandler = ErrorHandler.new
    @iCode = ICode.new
  end
  
  def parse
    nowTime = Time.now.to_f
    root = ICodeGen.generateNode(ICodeNType.COMPOUND)
    while not currentTk.is_a? EofToken
      token  = currentTk
      tkType = token.getType
      if not tkType == TkType.ERROR
      
        case tkType
          
          when TkType.EOL
            nextTk  
          else
            stmtParser = StatementParser.new(self)
            stmt       = stmtParser.parse(token)
            root.addBranch(stmt) if stmt
            
        end
        
      else
        @errHandler.flag(currentTk,currentTk.getValue,self)
      end
      # nextTk
    end
    @iCode.setRoot(root)
    
    elapsedTime = (Time.now.to_f - nowTime) * 1000
    sendMsg(Message.new(MsgType.PARSER_SUMMARY,[currentTk.getLine,
                                                  getErrorCount,
                                                  elapsedTime]))
  end
  
  def getErrorCount
    @errHandler.getErrorCount
  end
  
 protected
 
   def sync(syncSet)
   
     token = currentTk
     
     if not syncSet.include? token.getType
       @errHandler.flag(token,ErrCode.UNEXPECTED_TK,self)
       
       while !(token.is_a? EofToken) and !(syncSet.include? token.getType)
         token = nextTk
       end
     end
     return token
     
   end
   
   def skipEol
     while currentTk.is_a? EolToken
       nextTk
     end
   end
   
   def checkEol(token)
     tkType = token.getType
     if tkType == TkType.EOL or tkType == TkType.SEMICOLON then
       nextTk
     else
       @errHandler.flag(token,ErrCode.MISSING_EOL,self)
     end
   end


end
