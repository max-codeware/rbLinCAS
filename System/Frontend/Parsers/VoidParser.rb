#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class VoidTag < Enum

 enum_attr :DECLARED
 enum_attr :AHEAD
 enum_attr :INTERNAL
 
end
VTag = VoidTag.new

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
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
    if !voidName.getDef then
      voidName.setDef(Def.VOID)
    else
      voidState = voidName.getAttr(SymTabKey.VOID_STATE)
      if voidState then
        case voidState
          when VTag.DECLARED
            @errHandler.flag(token,ErrCode.VOID_DEFINED,self)
            voidName = makeDummy
          when VTag.AHEAD
            symTabPath = @@symTab.getCurrentPath
            @@symTab.setPath(voidName.getPath)
          when VTag.INTERNAL
            @errHandler.flag(token,ErrCode.CANNOT_CHANGE_INT,self)
            voidName = makeDummy
        end
      end
    end

    nextTk
    token  = sync(VOID_SYNC_SET)
    tkType = token.getType
    if voidState == VTag.AHEAD then     
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
      params = parseParams(token)
      voidName.setAttr(SymTabKey.VOID_ARGS,params)
      token = sync(VOID_SYNC_SET)
    end
    
    if token.getType != TkType.AHEAD then
      blcParser = BlockParser.new(self)
      iCode     = ICodeGen.generateICode
      iCode.setRoot(blcParser.parse(token))
      voidName.setAttr(SymTabKey.ICODE,iCode)
      voidName.setAttr(SymTabKey.VOID_STATE,VTag.DECLARED)
    else
      @errHandler.flag(token,ErrCode.ALREADY_FORWARDED,self) if voidState == VTag.AHEAD
      voidName.setAttr(SymTabKey.VOID_STATE,VTag.AHEAD)
      nextTk
    end
    
    disableReturn
    token = currentTk
    checkEol(token)
    @@symTab.exitLocal unless symTabPath
    @@symTab.setPath(symTabPath) if symTabPath
    
    return voidName.getPath
  end
  
 private
 
   def parseName(token)
     tkType = token.getType
     id = @@symTab.lookUpVoid(token.getText)
     if ! id then
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
       id = @@symTab.enterLocal(name)
     end
     return id
   end
   
   ARG_SYNC_SET = VOID_SYNC_SET + [TkType.L_IDENT] - [TkType.AHEAD,TkType.L_BRACE]
   
   def parseParams(token)
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
       if tkType == TkType.COMMA
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
     list
   end
   
   
   def createDummyName
     @@dummy += 1
     return "dummyVoid_#{@@dummy}"
   end
   
   def makeDummy
     voidName = createDummyName
     voidName = @@symTab.enterLocal(voidName)
     voidName.setDef(Def.VOID)
     voidName
   end

end






