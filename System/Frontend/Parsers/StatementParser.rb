#! /usr/bin/env ruby


##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class StatementParser < TDparser

  def initialize(source)
    super
  end
  
  def parse(token)
  
    root   = ICodeGen.generateNode(ICodeNType.NOTHING)  
    tkType = token.getType
    
    case tkType
      
      when TkType.VOID
        voidParser = VoidParser.new(self)
        voidName   = voidParser.parse(token)
        voidType   = voidName.getAttr(SymTabKey.VOID_TYPE)
        root       = ICodeGen.generateNode(ICodeNType.VOID)
        voidName.setAttr(SymTabKey.VOID_TYPE,VType.PUBLIC) unless voidType
        iCode      = voidName.getAttr(SymTabKey.ICODE)
        root.addBranch(iCode.getRoot) if iCode
        root.setAttr(ICKey.ID_PATH,voidName.getPath)
        
      when TkType.L_IDENT, TkType.G_IDENT, TkType.COLON_EQ
        assignParser = AssignParser.new(self)
        root         = assignParser.parse(token)
        
      when TkType.NAME
        idParser = IDparser.new(self)
        root     = idParser.parse(token)
        
      when TkType.IF
        ifParser = IfParser.new(self)
        root     = ifParser.parse(token)
        
      when TkType.SELECT
        selectParser = SelectParser.new(self)
        root         = selectParser.parse(token)
        
      when TkType.FOR
        forParser = ForParser.new(self)
        root      = forParser.parse(token)
        
      when TkType.FOREACH
        raise NotImplementedError, "Foreach loop has not been implemented yet"
        
      when TkType.RETURN
        root = parseReturn(token)
        
      when TkType.PRINT, TkType.PRINTL
        root = parseWrite(token)
        
      when TkType.READS
        root = ICodeGen.generateNode(ICodeNType.READ)
        nextTk
        
      when TkType.EOL
        root = ICodeGen.generateNode(ICodeNType.NOTHING)
        
      when TkType.DO
        token = nextTk
        if token.getType == TkType.WHILE
          whileParser = WhileParser.new(self)
          root        = whileParser.parse(token)
        else
          untilParser = UntilParser.new(self)
          root        = untilParser.parse(token)
        end 
      when TkType.NEW
        root = parseNew(token)  
      else
        @errHandler.flag(token,ErrCode.UNEXPECTED_TK,self)
        nextTk
        
    end
    setLineNum(root,token) if root
    
    return root
  end
  
  def reachNamespace(token)
    return reachNameSpace(token)
  end
  
  
 private
 
  def setLineNum(node,token)
     node.setAttr(ICKey.LINE,token.getLine) if node
  end
  
  def parseReturn(token)
    node      = ICodeGen.generateNode(ICodeNType.RETURN)
    expParser = ExpressionParser.new(self)
    node.addBranch(expParser.parse(nextTk))
    node
  end
  
  def parseWrite(token)
    node      = ICodeGen.generateNode(ICodeNType.PRINT)
    subNode   = ICodeGen.generateNode(ICodeNType.SBUFFER)
    node.setAttr(ICKey.ID,token.getText)
    token     = nextTk
    expParser = ExpressionParser.new(self)
    subNode.addBranch(expParser.parse(token))
    token  = currentTk
    tkType = token.getType
    while tkType == TkType.ADD and not token.is_a? EofToken
      nextTk
      skipEol
      token = currentTk
      subNode.addBranch(expParser.parse(token))
      token  = currentTk
      tkType = token.getType
    end
    node.addBranch(subNode)
    node
  end
  
  def parseNew(token)
    token = nextTk
    node  = ICodeGen.generateNode(ICodeNType.NEW)
    if token.getType == TkType.L_IDENT then
      id    = reachNameSpace(token)
    else
      @errHandler.flag(token,ErrCode.MISSING_ID,self)
      nextTk
      sync([TkType.EOL])
      return node
    end
    node.setAttr(ICKey.ID_PATH,id)
    node
  end
  
  def reachNameSpace(token)
    name = token.getText
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
    path = id.getPath
    id.getPath
  end


end
