#! /usr/bin/env ruby


##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ClassParser < TDparser

  CLASS_BEG_SET = [TkType.CLASS,TkType.L_IDENT,TkType.INHERITS,
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
      nameTk = token
      name   = token.getText
      nextTk
      token = sync(CLASS_BEG_SET)
    end
    id = @@symTab.lookUp(name)
    if id then
      if id.getDef == Def.CLASS
        @errHandler.flag(nameTk,ErrCode.LOCKED_CLASS,self) if id.getAttr(SymTabKey.ACCESS) == Access.LOCKED
        symTabPath = @@symTab.getCurrentPath
        @@symTab.setPath(id.getPath)
        oldICode = id.getAttr(SymTabKey.ICODE)
      else
        id = setClass(name)
      end
    else
      id = setClass(name)
    end
    tkType = token.getType
    if tkType == TkType.INHERITS then
      nextTk
      token  = sync(CLASS_BEG_SET)
      tkType = token.getType
      if tkType != TkType.L_IDENT
        @errHandler.flag(token,ErrCode.MISSING_ID,self)
      else
        parent = reachNameSpace(token)
        if id.getAttr(SymTabKey.PARENT) then
          @errHandler.flag(token,ErrCode.HAS_PARENT,self)
        else
          id.setAttr(SymTabKey.PARENT,parent)
          @@symTab.importGlobalFrom(parent)
        end
      end
    end
    bodyParser = BodyParser.new(self)
    bodyParser.classMode
    iCode      = ICodeGen.generateICode
    body       = bodyParser.parse(token)
    body.addBranch(oldICode.getRoot) if oldICode
    iCode.setRoot(body)
    id.setAttr(SymTabKey.ICODE,iCode)
    @@symTab.exitLocal unless symTabPath
    @@symTab.setPath(symTabPath) if symTabPath
    token  = currentTk
#    checkEol(token)
    id
  end
  
private

  def createDummyName
    @@dummy += 1
    name = "dummyClassName_#{@@dummy}"
    name
  end
  
  def setClass(name)
    id = @@symTab.enterLocal(name)
    id.setDef(Def.CLASS)
    id
  end
  
  def reachNameSpace(token)
    stmtParser = StatementParser.new(self)
    return stmtParser.reachNamespace(token)
  end

end











