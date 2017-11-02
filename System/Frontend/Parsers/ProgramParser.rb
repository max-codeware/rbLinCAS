#! /usr/bin/env ruby

##
# Accessibility enumeration
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class Accessibility < Enum
  enum_attr :LOCKED
end
Access = Accessibility.new

##
# ProgramParser parses all the statements of a program
#
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
class ProgramParser < TDparser

  def initialize(scanner)
    super
  end
  
  def parse(token)
    tkType = token.getType
    case tkType
      when TkType.CLASS
        klass = parseClass(token)
        node = makeClassNode(klass)
        
      when TkType.MODULE
        mod  = parseModule(token)
        node = makeClassNode(mod)
        
      when TkType.LOCKED
        token  = nextTk
        tkType = token.getType
        case tkType
          when TkType.CLASS
            klass = parseClass(token)
            klass.setAttr(SymTabKey.ACCESS,Access.LOCKED)
            node = makeClassNode(klass)
            
          when TkType.MODULE
            mod = parseModule(token)
            klass.setAttr(SymTabKey.ACCESS,Access.LOCKED)
            node = makeModuleNode(mod)
          else
            @errHandler.flag(token,ErrCode.WRONG_LOCKED_ARG,self)
        end
        
      else
        stmtParser = StatementParser.new(self)
        node = stmtParser.parse(token)
    end
    node
  end
  
private
  
  def parseClass(token)
    classParser = ClassParser.new(self)
    klass       = classParser.parse(token)
    klass
  end

  def parseModule(token)
  
  end
  
  def makeClassNode(klass)
    node  = ICodeGen.generateNode(ICodeNType.CLASS)
    node.addBranch(klass.getAttr(SymTabKey.ICODE).getRoot)
    node.setAttr(ICKey.ID_PATH,klass.getPath)
    node
  end
  
  def makeModuleNode(mNode)
    node  = ICodeGen.generateNode(ICodeNType.MODULE)
    node.addBranch(mNode.getAttr(SymTabKey.ICODE).getRoot)
    node.setAttr(ICKey.ID_PATH,klass.getPath)
    node
  end
  
end
