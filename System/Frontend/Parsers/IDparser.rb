#! /usr/bin/env ruby

class IDparser < ExpressionParser

  def initialize(scanner)
    super(scanner)
    @ignoreUndef = false
  end
  
  def parse(token)
    return parseID(token)
  end
  
  def ignoreUndef
    @ignoreUndef = true
  end
  
 private
 
    def parseID(token)
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
          id = parseNameSpace(idToken)
          callNode = ICodeGen.generateNode(ICodeNType.METHOD_CALL)
          callNode.addBranch(id)
          token  = currentTk
          tkType = token.getType
          if tkType == TkType.DOT
            callNode = parseMethodCall(token,callNode)
          end
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
      if @@voidBuff.definedLocally?(name)
        methodName.setAttr(ICKey.ID,name)
        methodName.setAttr(ICKey.OWNER_NAME,topName)
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
      if ! tkType == TkType.L_IDENT then
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
          
        df = @@symbolTabStack.lookUpLocal(name)
        if not df then
          @errHandler.flag(token,ErrCode.UNDEF_IDENT,self) unless @ignoreUndef
          df = @@symbolTabStack.enterLocal(name)
          df.setDef(Tp.UNDEF)
        end
          
        root = ICodeGen.generateNode(ICodeNType.LVARIABLE)
        df.addLineNum(token.getLine)
        root.setAttr(ICKey.ID,df)
                 
       else
          
         root = ICodeGen.generateNode(ICodeNType.SVARIABLE)
         root.setAttr(ICKey.ID,name)
          
       end
       root
     end
     
     def parseGIdent(token)
       name = token.getText
       stateLevel = getStateLevel
       nestingLevel = @@symbolTabStack.getCurrentNLevel
       while getStateAt(stateLevel) == ParsingSt.VOID
         stateLevel   -= 1
         nestingLevel -= 1
       end
       id = @@symbolTabStack.lookUp(name,nestingLevel)
       if ! id then
         @errHandler.flag(token,ErrCode.UNDEF_IDENT,self) unless @ignoreUndef
         id = @@symbolTabStack.enterAt(name,nestingLevel)
         id.setDef(Tp.UNDEF)
       end
       
       root = ICodeGen.generateNode(ICodeNType.LVARIABLE)
       id.addLineNum(token.getLine)
       root.setAttr(ICKey.ID,id)
       root
     end
     
     def parseNameSpace(token)
       node = ICodeGen.generateNode(ICodeNType.NAMESPACE)
       name = ICodeGen.generateNode(ICodeNType.NAME)
       name.setAttr(ICKey.ID,token.getText)
       node.addBranch(name)
       token  = currentTk
       tkType = token.getType
       while tkType == TkType.COLON and not token.is_a? EolToken
         token  = nextTk
         tkType = token.getType
         @errHandler.flag(token,ErrCode.MISSING_NAME,self) if tkType != TkType.NAME
         name = ICodeGen.generateNode(ICodeNType.NAME)
         name.setAttr(ICKey.ID,token.getText)
         node.addBranch(name)
         token  = nextTk
         tkType = token.getType
       end
       node
     end

end
