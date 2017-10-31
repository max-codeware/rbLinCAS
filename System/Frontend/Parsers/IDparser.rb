#! /usr/bin/env ruby

##
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class IDparser < ExpressionParser

  def initialize(scanner)
    super(scanner)
    @ignoreUndef = false
  end
  
  def parse(token)
    return parseID(token)
  end
  
  def parseIdOnly(token)
    id = parseIDType(token)
    nextTk
    id
  end
  
  def ignoreUndef
    @ignoreUndef = true
  end
  
 private
 
    def parseID(token)
      node  = parseBeg(token)
      loop do
        token = currentTk
        tkType = token.getType
        case tkType
          when TkType.DOT
            callNode = ICodeGen.generateNode(ICodeNType.METHOD_CALL)
            callNode.addBranch(node)
            callNode = parseMethodCall(token,callNode)
            node     = callNode
          when TkType.COLON
            node = parseNameSpace(token,node)
          when TkType.L_BRACKET
            callNode = ICodeGen.generateNode(ICodeNType.INDEX_CALL)
            callNode.addBranch(node)
            callNode.addBranch(parseIndex(token))
            node = callNode
          else
            return node
        end
      end
    end
 
    def parseBeg(token)
      idToken = token
      token  = nextTk
      tkType = token.getType
      case tkType
        when TkType.DOT
          @ignoreUndef = false
          id = parseIDtype(idToken)
          callNode = ICodeGen.generateNode(ICodeNType.METHOD_CALL)
          callNode.addBranch(id)
          callNode = parseMethodCall(token,callNode)
        when TkType.COLON
          callNode = parseNameSpace(idToken)
        when TkType.L_PAR
          @ignoreUndef = false
          methodName = lookUpVoid(idToken)
          callNode   = ICodeGen.generateNode(ICodeNType.CALL)
          callNode.addBranch(methodName)
          callNode.addBranch(parseArgs(token))
        when TkType.L_BRACKET
          @ignoreUndef = false
          id = parseIDtype(idToken)
          callNode = ICodeGen.generateNode(ICodeNType.INDEX_CALL)
          callNode.addBranch(id)
          callNode.addBranch(parseIndex(token))
        else
          return parseIDtype(idToken)
      end
      return callNode
    end
    
    def parseArgs(token)
      tkType = token.getType
      
      if !(tkType == TkType.L_PAR) then
        @errHandler.flag(token,ErrCode.MISSING_L_PAR,self)
      else
        nextTk
        skipEol
        token = currentTk
      end
      
      args      = ICodeGen.generateNode(ICodeNType.ARGS)
      tkType = token.getType
      unless tkType == TkType.R_PAR
        expParser = ExpressionParser.new(self)
        arg       = expParser.parse(token)
        args.addBranch(arg)
        token  = currentTk
        tkType = token.getType
        
        while (tkType == TkType.COMMA) and !(token.is_a? EofToken)
          nextTk
          skipEol
          token = currentTk
          
          if token.getType == TkType.R_PAR then
            @errHandler.flag(token,ErrCode.MISSING_ARG,self)
            break
          end
          args.addBranch(expParser.parse(token))
          token  = currentTk
          tkType = token.getType
          
        end
      end
      
      skipEol
      token  = currentTk
      tkType = token.getType
      if !(tkType == TkType.R_PAR) then
        @errHandler.flag(token,ErrCode.MISSING_R_PAR,self)
      else
        nextTk
      end
      return args
    end
    
    def parseIndex(token)
      nextTk
      skipEol
      token = currentTk
      index = ICodeGen.generateNode(ICodeNType.INDEX)
      expParser = ExpressionParser.new(self)
      index.addBranch(expParser.parseSimpleExp(token)) unless token.getType == TkType.R_BRACKET
      token  = currentTk
      tkType = token.getType
      while tkType == TkType.COMMA and not token.is_a? EofToken
        nextTk
        skipEol
        token  = currentTk
        tkType = token.getType
        if tkType == TkType.R_BRACKET then
          @errHandler.flag(token,ErrCode.MAYBE_MISS_INDEX,self)
          break
        end
        index.addBranch(expParser.parseSimpleExp(token))
        token  = currentTk
        tkType = token.getType
      end
      if not tkType == TkType.R_BRACKET then
        @errHandler.flag(token,ErrCode.MISSING_R_BRACKET,self)
      else
        nextTk
      end
      index
    end
    
    def lookUpVoid(token)
      methodName = ICodeGen.generateNode(ICodeNType.METHOD_NAME)
      if token.getType != TkType.L_IDENT then
        @errHandler.flag(token,ErrCode.INVALID_CALL_NAME,self)
        methodName.setAttr(ICKey.ID,token.getText)
        return methodName
      end
      name = token.getText
      id = @@symTab.lookUpVoid(name)
      if id then
        methodName.setAttr(ICKey.ID_PATH,id.getPath)
      else
        @errHandler.flag(token,ErrCode.UNDEF_VOID,self)
        methodName.setAttr(ICKey.ID,name)
      end
      methodName
    end
    
    def parseMethodCall(token,callNode)
      tkType = token.getType
      if not tkType = TkType.DOT then
        @errHandler.flag(token,ErrCode.MISSING_DOT,self)
      else
        token  = nextTk
        tkType = token.getType
      end
      methodName = ICodeGen.generateNode(ICodeNType.METHOD_NAME)
      if tkType == TkType.EOL then
        @errHandler.flag(token,ErrCode.UNEXPECTED_EOL,self)
        return callNode
      end
      if !(tkType == TkType.L_IDENT) then
        @errHandler.flag(token,ErrCode.INVALID_CALL_NAME,self)
        methodName.setAttr(ICKey.ID,"dummyName")      
      else
        name = token.getText
        methodName.setAttr(ICKey.ID,name)
      end
      methodName.setAttr(ICKey.LINE,token.getLine)
      callNode.addBranch(methodName)
      token = nextTk
      callNode.addBranch(parseArgs(token))
      return callNode
    end 
    
    def parseIDtype(token)
      tkType = token.getType
      case tkType
        when TkType.L_IDENT
          id = parseLIdent(token)
        when TkType.G_IDENT
          id = parseGIdent(token)
      end
      id
    end
    
    def parseLIdent(token)
      name = token.getText
      if not @@sym then 
        df = @@symTab.lookUpLocal(name)
        if not df then
          @errHandler.flag(token,ErrCode.UNDEF_IDENT,self) unless @ignoreUndef
          df = @@symTab.enterLocal(name)
          df.setDef(Def.L_IDENT)
          df.setAttr(SymTabKey.TYPE,Tp.UNDEF)
          @@symTab.exitLocal
        end
        df.addLineNum(token.getLine)
        root = ICodeGen.generateNode(ICodeNType.LVARIABLE)
        root.setAttr(ICKey.ID_PATH,df.getPath)       
      else 
        root = ICodeGen.generateNode(ICodeNType.SVARIABLE)
        root.setAttr(ICKey.ID,name)    
      end
      root
    end
     
    def parseGIdent(token)
      name = token.getText
      id = @@symTab.lookUpGlobal(name)
      if ! id then
        @errHandler.flag(token,ErrCode.UNDEF_IDENT,self) unless @ignoreUndef
        id = @@symTab.enterGlobal(name)
        id.setDef(Def.G_IDENT)
        id.setAttr(SymTabKey.TYPE,Tp.UNDEF)
      end
      id.addLineNum(token.getLine)
      root = ICodeGen.generateNode(ICodeNType.GVARIABLE)
      root.setAttr(ICKey.ID_PATH,id.getPath)
      root
    end
    
    def parseNameSpace(token,beginning = nil)
      node = ICodeGen.generateNode(ICodeNType.NAMESPACE)
      if beginning
        node.addBranch(beginning) 
      else
        name = ICodeGen.generateNode(ICodeNType.NAME)
        name.setAttr(ICKey.ID,token.getText)
        node.addBranch(name)
      end
      token  = currentTk
      tkType = token.getType
      while tkType == TkType.COLON and not token.is_a? EolToken
        token  = nextTk
        tkType = token.getType
        @errHandler.flag(token,ErrCode.MISSING_NAME,self) if tkType != TkType.L_IDENT
        name = ICodeGen.generateNode(ICodeNType.NAME)
        name.setAttr(ICKey.ID,token.getText)
        node.addBranch(name)
        token  = nextTk
        tkType = token.getType
      end
      node.setAttr(ICKey.PATH,@@symTab.getCurrentPath.clone) unless beginning
      node
    end
    
end
