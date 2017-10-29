#! /usr/bin/env ruby

class VoidTag < Enum

 enum_attr :DECLARED
 enum_attr :AHEAD
 enum_attr :INTERNAL
 
end
VTag = VoidTag.new

class VoidParser < TDparser

  VOID_SYNC_SET = [TkType.L_PAR,TkType.R_PAR,TkType.AHEAD,
                   TkType.L_BRACE,TkType.EOL,TkType.SEMICOLON]

  def initialize(scanner)
    super
  end
  
  def parse(token)
    token = nextTk
    enableReturn
    
    voidName = parseName(token)
    if @@voidBuff.definedLocally?(voidName) then
      tag = @@voidBuff.getTagOf(voidName)
      case tag
        when VTag.DECLARED
          @@symbolTabStack.push
        when VTag.AHEAD
          @@symbolTabStack.push(@@voidBuff.getSymTabOf(voidName))
        when VTag.INTERNAL
          @errHandler.flag(token,ErrCode.CANNOT_CHANGE_INT,self)
          voidName = createDummyName
          initializeVoid(voidName)
      end
    else
      initializeVoid(voidName)
    end
    
    pushState ParsingSt.VOID
    
    nextTk
    token  = sync(VOID_SYNC_SET)
    tkType = token.getType
    if tag == VTag.AHEAD then     
      if tkType != TkType.L_PAR
        @errHandler.flag(token,ErrCode.MISSING_L_PAR,self) 
      else
        nextTk
        token = sync(VOID_SYNC_SET)
      end
      tkType = token.getType
      if tkType != TkType.R_PAR then
        @errHandler.flag(token,ErrCode.MISSING_R_PAR,self)
      else
        nextTk
        token = sync(VOID_SYNC_SET)
      end
    else
      parseParams(token,voidName)
      token = sync(VOID_SYNC_SET)
    end
    
    if token.getType != TkType.AHEAD then
      blcParser = BlockParser.new(self)
      iCode     = ICodeGen.generateICode
      iCode.setRoot(blcParser.parse(token))
      @@voidBuff.setICodeAt(voidName,iCode)
      @@voidBuff.setTagAt(voidName,VTag.DECLARED)
    else
      @@errHandler.flag(token,ErrCode.ALREADY_FORWARDED,self) if tag == VTag.AHEAD
      nextTk
    end
    
    @@voidBuff.setSymTabAt(voidName,@@symbolTabStack.pop)
    disableReturn
    token = currentTk
    checkEol(token)
    popState
    
    return voidName
  end
  
 private
 
   def parseName(token)
     tkType = token.getType
     id = @@symbolTabStack.lookUpLocal(token.getText)
     if id then
       @errHandler.flag(token,ErrCode.ID_DEFINED,self)
       return createDummyName
     end
     case tkType
       when TkType.L_PAR
         @errHandler.flag(token,ErrCode.MISSING_ID,self)
         name = createDummyName
       when TkType.G_IDENT
         @errHandler.flag(token,ErrCode.MISSING_ID,self)
         name = token.getText
       when TkType.L_IDENT
         name = token.getText
       else
         @errHandler.flag(token,ErrCode.MISSING_ID,self)
         name = createDummyName
     end
     return name
   end
   
   ARG_SYNC_SET = VOID_SYNC_SET + [TkType.L_IDENT] - [TkType.AHEAD,TkType.L_BRACE]
   
   def parseParams(token,voidName)
     token = sync(ARG_SYNC_SET)
     tkType = token.getType
     if tkType != TkType.L_PAR
        @errHandler.flag(token,ErrCode.MISSING_L_PAR,self) 
     else
       nextTk
       skipEol
       token = sync(ARG_SYNC_SET)
     end
     
     tkType   = token.getType
     idParser = IDparser.new(self)
     idParser.ignoreUndef
     list     = []
     while tkType == TkType.L_IDENT do
       id = idParser.parse(token)
       list << id if id
       token  = currentTk
       tkType = token.getType
       if tkType = TkType.COMMA
         nextTk
         skipEol
         token = sync(ARG_SYNC_SET)
       else
         @errHandler.flag(token,ErrCode.MISSING_COMMA,self) unless tkType == TkType.R_PAR
         token = sync(ARG_SYNC_SET)
       end
       tkType = token.getType
     end
     if tkType != TkType.R_PAR then
       @errHandler.flag(token,ErrCode.MISSING_R_PAR,self)
     else
       nextTk
     end
     @@voidBuff.setArgsAt(voidName,list)
   end
   
   
   def createDummyName
     @@dummy += 1
     return "dummyVoid_" + @@dummy.to_s
   end
   
   def initializeVoid(voidName)
     @@voidBuff.addVoidName(voidName)
     @@symbolTabStack.push
   end

end






