#! /usr/bin/env ruby


##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ClassParser < TDparser

  CLASS_BEG_SET = [TkType.CLASS,TkType.L_IDENT,TkType.INHERIT,
                   TkType.L_BRACE,TkType.EOL]
  
  def initialize(scanner)
    super
  end
  
  def parse(token)
    nextTk
    token  = sync(CLASS_BEG_SET)
    tkType = token.getType
    if tkType != TkType.L_IDENT then
      @errHandler.flag(token,ErrCode.MISSING_ID,self)
      name = createDummyName
    else
      name = token.getText
      nextTk
      token = sync(CLASS_BEG_SET)
    end
    id = @@symTab.lookUp(name)
    if id then
      if id.getDef == Def.CLASS
        symTabPath = @@symTab.getCurrentPath
        @@symTab.setPath(id.getPath)
      else
        id = setClass
      end
    else
      id = setClass
    end
    tkType = token.getType
    if tkType == TkType.INHERIT then
      nextTk
      token  = sync(CLASS_BEG_SET)
      tkType = token.getType
      if tkType != TkType.L_IDENT
        @errHandler(token,ErrCode.MISSING_ID,self)
      else
        parent = reachNameSpace(token)
        id.setAttr(SymTabKey.PARENT,parent)
      end
    end
    bodyParser = BodyParser.new(self)
    bodyParser.classMode
    iCode      = ICodeGen.generateICode
    iCode.setRoot(bodyParser.parse(token))
    id.setAttr(SymTabKey.ICODE,iCode)
    @@symTab.exitLocal unless symTabPath
    @@symTab.setPath(symTabPath) if symTabPath
    id
  end
  
private

  def createDummyName
    @@dummy += 1
    name = "dummyClassName_#{@@dummy}"
    name
  end
  
  def setClass(name)
    id = @@symTab.enterLocal
    id.setDef(Def.CLASS)
    id
  end
  
  def reachNameSpace(token)
    name = token.getName
    id   = @@symTab.lookUp(name)
    
    if ! id then
      @errHandler.flag(token,ErrCode.UNDEF_IDENT,self)
      return name
    end
    
    token  = nextTk
    oldTk  = token
    tkType = token.getType
    
    while tkType == TkType.COLON do
    
      token  = nextTk
      tkType = token.getType
      
      if tkType == TkType.L_IDENT
        name = token.getText
        subId = id.lookUpLocal(name)
        
        if ! subId then
          @errHandler.flag(token,ErrCode.UNDEF_IDENT_FOR % id.getPath.to_s,self)
          return id.getPath
        else
          id = subId
        end
        
      else
      
        @errHandler.flag(token,ErrCode.MISSING_NAME,self)
        return id.getPath
        
      end
      
      token  = nextTk
      oldTk  = token
      tkType = token.getType
      
    end
    
    idDef = id.getDef
    
    if idDef != Def.CLASS then
      @errHandler.flag(oldTk,ErrCode.IS_NOT_A_CLASS % id.getName,self)
    end
    
    id.getPath
  end

end











