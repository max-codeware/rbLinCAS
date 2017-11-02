#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ModuleParser < TDparser

  MODULE_SYNC_SET = [TkType.L_IDENT,TkType.L_BRACE,TkType.EOL]
  
  def initialize(scanner)
    super
  end
  
  def parse(token)
    nextTk
    token  = sync(MODULE_SYNC_SET)
    tkType = token.getType
    if tkType != TkType.L_IDENT then
      @errHandler.flag(token,ErrCode.MISSING_ID,self)
      name = createDummyName
    else
      nameTk = token
      name   = token.getText
      nextTk
      token = sync(CLASS_BEG_SET)
    end
    
    id = @@symTab.lookUp(name)
    if id then
      if id.getDef == Def.MODULE then
        @errHandler.flag(nameTk,ErrCode.LOCKED_MODULE,self) if id.getAttr(SymTabKey.ACCESS) == Access.LOCKED
        symTabPath = @@symTab.getPath
        @@symTab.setPath(id.getPath)
        oldIcode = id.getAttr(SymTabKey.ICODE)
      else
        id = setModule(name)
      end
    else
      id = setModule(name)
    end
    
    bodyParser = BodyParser.new(self)
    iCode      = ICodeGen.generateICode
    body       = bodyParser.parse(token)
    body.addBranch(oldICode.getRoot) if oldICode
    iCode.setRoot(body)
    id.setAttr(SymTabKey.ICODE,iCode)
    @@symTab.exitLocal unless symTabPath
    @@symTab.setPath(symTabPath) if symTabPath
    token  = currentTk
    checkEol(token)
    id
  end
  
private

  def createDummyName
    @@dummy += 1
    name = "dummyModuleName_#{@@dummy}"
    name
  end
  
  def setModule(name)
    id = @@symTab.enterLocal(name)
    id.setDef(Def.MODULE)
    id
  end

end
