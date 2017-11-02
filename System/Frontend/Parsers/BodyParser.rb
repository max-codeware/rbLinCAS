#! /usr/bin/env ruby

##
# BodyParser parses the body of a class or a module
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class BodyParser < TDparser

  BODY_BEG_SET = STMT_BEG_SET - [TkType.SEMICOLON,TkType.L_BRACKET] +
                 [TkType.LOCKED,TkType.CLASS,TkType.MODULE,TkType.VOID,
                  TkType.PUBLIC,TkType.PRIVATE,TkType.PROTECTED]

  def initialize(scanner)
    super(scanner)
    @classMode = false
  end
  
  def classMode
    @classMode = true
  end
  
  def parse(token)
    body = ICodeGen.generateNode(ICodeNType.COMPOUND)
    skipEol
    token  = sync(BODY_BEG_SET)
    tkType = token.getType
    if tkType != TkType.L_BRACE then
      @errHandler.flag(token,ErrCode.MISSING_L_BRACE,self)
    else
      nextTk
      skipEol
      token  = currentTk
      tkType = token.getType
    end
    
    if @classMode then
      slf = @@symTab.enterLocal("@self")
      slf.setDef(Def.AUTOREF)
      @@symTab.exitLocal
    end
    
    while tkType != TkType.R_BRACE and not token.is_a? EofToken
      prevTk = token
      case tkType
        when TkType.PRIVATE
          @errHandler.flag(token,ErrCode.PRIVATE_IN_MODULE,self) unless @classMode
          token = nextTk
          void = parseVoid(token)
          voidType = void.getAttr(SymTabKey.VOID_TYPE)
          if !voidType
            void.setAttr(SymTabKey.VOID_TYPE,VType.PRIVATE)
          elsif voidType != VType.PRIVATE
            @errHandler.flag(prevTk,ErrCode.REDEFINING_ACCESS,self)
          end
          body.addBranch(makeVoidNode(void))
        when TkType.PROTECTED
          @errHandler.flag(token,ErrCode.PROTECTED_IN_MODULE,self) unless @classMode
          token = nextTk
          void = parseVoid(token)
          voidType = void.getAttr(SymTabKey.VOID_TYPE)
          if !voidType
            void.setAttr(SymTabKey.VOID_TYPE,VType.PROTECTED)
          elsif voidType != VType.PROTECTED
            @errHandler.flag(prevTk,ErrCode.REDEFINING_ACCESS,self)
          end
          body.addBranch(makeVoidNode(void))
        when TkType.PUBLIC
          token = nextTk
          void = parseVoid(token)
          voidType = void.getAttr(SymTabKey.VOID_TYPE)
          if !voidType
            void.setAttr(SymTabKey.VOID_TYPE,VType.PUBLIC)
          elsif voidType != VType.PUBLIC
            @errHandler.flag(prevTk,ErrCode.REDEFINING_ACCESS,self)
          end
          body.addBranch(makeVoidNode(void))
        else
          programParser = ProgramParser.new(self)
          body.addBranch(programParser.parse(token))
      end
      skipEol
      token  = currentTk
      tkType = token.getType
    end
    
    if tkType == TkType.R_BRACE then
      nextTk
    elsif token.is_a? EofToken
      @errHandler.flag(token,ErrCode.UNEXPECTED_EOF,self)
      @errHandler.abortSystem
    else
      @errHandler.flag(token.ErrCode.MISSING_R_BRACE,self)
    end
    body
  end
  
private

  def parseVoid(token)
    voidParser = VoidParser.new(self)
    void       = voidParser.parse(token)
    void
  end
  
  def makeVoidNode(void)
    voidTag = void.getAttr(SymTabKey.VOID_STATE)
    voidNode   = ICodeGen.generateNode(ICodeNType.VOID)
    voidNode.addBranch(void.getAttr(SymTabKey.ICODE).getRoot) unless voidTag == VTag.AHEAD
    voidNode.setAttr(ICKey.ID_PATH,void.getPath)
    voidNode
  end
  
end
