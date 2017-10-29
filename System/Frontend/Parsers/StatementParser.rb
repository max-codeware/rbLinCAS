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
        @@voidBuff.setTypeAt(voidName,VType.PUBLIC)
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
        # foreachParser = ForeachParser.new(self)
        # root          = foreachParser.parse(token)
      when TkType.RETURN
        root = parseReturn(token)
      when TkType.DO
        token = nextTk
        if token.getType == TkType.WHILE
          whileParser = WhileParser.new(self)
          root        = whileParser.parse(token)
        else
          untilParser = UntilParser.new(self)
          root        = untilParser.parse(token)
        end 
      # when TkType.EOL, TkType.SEMICOLON
      #  nextTk
      else
        @errHandler.flag(token,ErrCode.UNEXPECTED_TK,self)
        nextTk
        
    end
    setLineNum(root,token) if root

    return root
  end
  
  
 private
 
  def setLineNum(node,token)
     node.setAttr(ICKey.LINE,token.getLine) if node
  end
  
  def parseReturn(token)
  
  end


end
