#! /usr/bin/env ruby

class StatementExecutor < MessageGenerator
  
  def initialize(vMemory,symTab = nil)
    @vMemory     = vMemory
    @vMemory.push("Main")
    #@rErrHandler = RuntimeErrHandler.new
    @symTab      = symTab if symTab and not @symTab
    @@msgHandler = MessageHandler.new  unless defined? @@msgHandler
  end
  
  def messageHandler
    @@msgHandler
  end
  
  def execute(iCode)
    program = iCode.getRoot
    executeProgram(program)
    puts 
  end
  
protected

  def executeProgram(program)
    nodes = program.getBranches
    nodes.each do |node|
      executeNodes(node)
    end
  end
  
  def executeNodes(node)
    nodeType = node.getType
    out      = nil
    case nodeType
      when ICodeNType.IF
        out = executeIf(node)
      when ICodeNType.SELECT
        out = executeSelect(node)
      when ICodeNType.WHILE
        out = executeWhile(node)
      when ICodeNType.UNTIL
        out = executeUntil(node)
      when ICodeNType.COMPOUND
        out = executeCompound(node)
      when ICodeNType.ASSIGN
        executeAssign(node)
      when ICodeNType.PRINT
        executePrint(node)
      when ICodeNType.RETURN
        out = executeReturn(node)
      when ICodeNType.READ
        out = executeRead
      when ICodeNType.CALL
        out = executeCall(node)
      when ICodeNType.METHOD_CALL
        out = executeMethodCall(node)
    end
    out
  end
  
  def executeIf(node)
    out          = nil
    branches     = node.getBranches
    condition    = branches[0]
    branch1      = branches[1]
    branch2      = branches[2]
    conditionVal = executeExpr(condition)
    if conditionVal then
      out = executeBlock(branch1)
    else
      out = executeBlock(branch2) if branch2
    end
    out
  end
  
  def executeSelect(node)
    out        = nil
    branches   = node.getBranches
    test       = branches[0]
    selectHash = makeSelectHash(branches)
    testVal    = executeExpr(test)
    if selectHash.keys.include? testVal
      block      = selectHash[testVal]
    else
      block      = selectHash("else")
    end
    out = executeBlock(block) if block
    out
  end
  
  def executeWhile(node)
    out      = nil
    branches = node.getBranches
    test     = branches[0]
    block    = branches[1]
    testVal  = executeExpr(test)
    while testVal
      out = executeBlock(block)
      return out if out
      testVal = executeExpr(test)
    end
    out
  end
  
  def executeUntil(node)
    out      = nil
    branches = node.getBranches
    block    = branches[0]
    test     = branches[1]
    loop do
      out = executeBlock(block)
      return out if out
      testVal = executeExpr(test)
      break if testVal
    end
  end
  
  def executeCompound(node)
    out      = nil
    branches = node.getBranches
    branches.each do |branch|
      out = executeNodes(branch)
      return out if out
    end
    out
  end
  
  def executeAssign(node)
    branches = node.getBranches
    toAssign = branches[0]
    expr     = branches[1]
    exprVal  = executeExpr(expr)
    nodeType = toAssign.getType
    case nodeType
      when ICodeNType.GVARIABLE
        var = @symTab.get(toAssign.getAttr(SymTabKey.ID_PATH))
        if var
          varName = var.getName
          @vMemory.gmalloc(varName,exprVal)
        else
          @rErrHandler
        end
        
      when ICodeNType.LVARIABLE
        var = @symTab.get(toAssign.getAttr(ICKey.ID_PATH))
        if var
          varName = var.getName
          @vMemory.lmalloc(varName,exprVal)
        else
          @rErrHandler
        end
      when ICodeNType.INDEX_CALL
      
        
    end
  end
  
  def executePrint(node)
    printType = node.getAttr(ICKey.ID)
    branches  = node.getBranches
    buffer    = branches[0]
    elements  = buffer.getBranches
    elements.each do |element|
      string = executeExpr(element)
      print string
    end
    puts if printType.upcase.to_sym == TkType.PRINTL
    nil
  end
  
  def executeReturn(node)
    branch = node.getBranches
    out    = executeExpr(branch)
    out
  end
  
  def executeRead(node)
    readed = $stdin.gets
    readed
  end
  
  def executeCall(node)
  
  end
  
  def executeMethodCall(node)
  
  end
  
  def executeBlock(node)
    out      = nil
    branches = node.getBranches
    branches.each do |branch|
      out = executeNodes(branch)
      return out if out
    end
    out
  end
  
  def executeExpr(node)
    out      = nil
    nodeType = node.getType
    case nodeType
      when ICodeNType.ADD
        out = executeAdd(node)
      when ICodeNType.SUB
        out = executeSub(node)
      when ICodeNType.MULT
        out = executeMult(node)
      when ICodeNType.FDIV
        out = executeFDiv(node)
      when ICodeNType.IDIV
        out = executeIDiv(node)
      when ICodeNType.MOD
        out = executeMod(node)
      when ICodeNType.INVERT
        out = executeNegate(node)
      when ICodeNType.POWER
        out = executePower(node)
      when ICodeNType.AND
        out = executeAnd(node)
      when ICodeNType.OR
        out = executeOr(node)
      when ICodeNType.EQ
        out = executeEq(node)
      when ICodeNType.NE
        out = executeNe(node)
      when ICodeNType.GR
        out = executeGr(node)
      when ICodeNType.SM
        out = executeSm(node)
      when ICodeNType.GE
        out = executeGe(node)
      when ICodeNType.SE
        out = executeSe(node)
      else
        out = executeAtom(node)
    end
    out
  end
  
  def executeAdd(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal + rightVal
    out
  end
  
  def executeSub(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal - rightVal
    out
  end
  
  def executeMult(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal * rightVal
    out
  end
  
  def executeFDiv(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal / rightVal.to_s
    out
  end
  
  def executeIDiv(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal / rightVal.to_i
    out
  end
  
  def executeMod(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal % rightVal
    out
  end
  
  def executeNegate(node)
    out      = nil
    branches = node.getBranches
    expr     = branches[0]
    exprVal  = executeExpr(expr)
    out      = - exprVal
    out
  end
  
  def executePower(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal ** rightVal
    out
  end
  
  def executeAnd(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal and rightVal
    out
  end
  
  def executeOr(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal or rightVal
    out
  end
  
  def executeEq(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal == rightVal
    out
  end
  
  def executeNe(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal != rightVal
    out
  end
  
  def executeGr(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal > rightVal
    out
  end
  
  def executeSm(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal < rightVal
    out
  end
  
  def executeGe(node)
    out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal >= rightVal
    out
  end
  
  def executeSe(node)
     out      = nil
    branches = node.getBranches
    left     = branches[0]
    right    = branches[1]
    leftVal  = executeExpr(left)
    rightVal = executeExpr(right)
    out      = leftVal <= rightVal
    out
  end
  
  def executeAtom(node)
    out      = nil
    nodeType = node.getType
    case nodeType
      when ICodeNType.INT
        out = node.getAttr(ICKey.VALUE)
      when ICodeNType.FLOAT
        out = node.getAttr(ICKey.VALUE)
      when ICodeNType.STRING_CONST
        out = node.getAttr(ICKey.VALUE)
      when ICodeNType.SYMBOLIC
        out = executeSymbolic(node)
      when ICodeNType.MATRIX
        out = executeMatrix(node)
      when ICodeNType.NEW
        out = executeNew(node)
      when ICodeNType.GVARIABLE
        var = @symTab.get(node.getAttr(ICKey.ID_PATH))
        if var
          varName = var.getName
          out = @vMemory.gGet(varName)
        else
          @rErrHandler
        end
      when ICodeNType.LVARIABLE
        var = @symTab.get(node.getAttr(ICKey.ID_PATH))
        if var
          varName = var.getName
          out = @vMemory.lGet(varName)
        else
          @rErrHandler
        end
      when ICodeNType.MATH_FUNCT
        out = executeMathFunct(node)
      when ICodeNType.BOOL_CONST
        out = executeBoolConst(node)
      when ICodeNType.INDEX_CALL
        out = executeIndexCall(node)
      when ICodeNType.METHOD_CALL
        out = executeMethodCall(node)
      when ICodeNType.CALL
        out = executeCall(node)
    end
    out
  end
  
  def executeSymbolic(node)
  
  end
  
  def executeMatrix(node)
  
  end
  
  def executeNew(node)
  
  end
  
  def executeMathFunct(node)
  
  end
  
  def executeBoolConst(node)
  
  end
  
  def executeIndexCall(node)
  
  end
  
private

  def makeSelectHash(branches)
    selectHash = {}
    for i in 1...branches.size
      caseNode  = branches[i]
      caseNtype = caseNode.getType
      case caseNtype
        when ICodeNType.CASE
          caseBranches = caseNode.getBranches
          c_set        = caseBranches[0]
          block        = caseBranches[1]
          cases        = c_set.getBranches
          cases.each do |cas|
            cs = executeExpr(cas)
            selectHash[cs] = block
          end
        when ICodeNType.ELSE
          selectHash["else"] = caseNode.getBranch
      end
    end
    selectHash
  end
  
end


















