#! /usr/bin/env ruby

class MatrixParser < TDparser

  def initialize(source)
    super
  end
  
  def parse(token)
  
    @columnNumber = -1 
    
    token      = nextTk
    expParser  = ExpressionParser.new(self)
    matrixNode = ICodeGen.generateNode(ICodeNType.MATRIX)
    arrayNode  = ICodeGen.generateNode(ICodeNType.MATRIX) 
    col        = expParser.parse(token)
    rw         = true if col
    arrayNode.addBranch(col.clone) if col
    token      = currentTk
    tkType     = token.getType

    while tkType != TkType.R_BRACKET and not token.is_a? EofToken and tkType != TkType.EOL
      
      case tkType
      
        when TkType.SEMICOLON
        
          # puts token.getType
          matrixNode.addBranch(arrayNode.clone)
          checkRow(arrayNode.getBranches.size,token)
          
          arrayNode  = ICodeGen.generateNode(ICodeNType.MATRIX)
          token  = nextTk
          col    = expParser.parse(token)
          rw     = col ? true : false
          arrayNode.addBranch(col.clone) if col 
          token  = currentTk
          tkType = token.getType
        
        when TkType.COMMA
        
          token = nextTk        
          col   = expParser.parse(token)
          arrayNode.addBranch(col.clone) if col
          token  = currentTk
          tkType = token.getType
          
        
        else
          
          @errHandler.flag(token,ErrCode.UNEXPECTED_TK,self) unless token.is_a? EolToken
          token  = nextTk
          tkType = token.getType
          
      end
      
    end
    
    if rw then
      matrixNode.addBranch(arrayNode)
      checkRow(arrayNode.getBranches.size,token)
    end
    
    case tkType
    
      when TkType.R_BRACKET
        nextTk
      when TkType.EOL
        @errHandler.flag(token,ErrCode.MISSING_R_BRACKET,self)
      when TkType.EOF
        @errHandler.flag(token,ErrCode.UNEXPECTED_EOF,self)
      else
        @errHandler.flag(token,ErrCode.UNEXPECTED_TK,self)
    end 
    return matrixNode
  end
  
 private
 
   def checkRow(currentSize,token)
     if @columnNumber == -1
       @columnNumber = currentSize
     else
       @errHandler.flag(token,ErrCode.IRREGULAR_MATRIX,self) unless currentSize == @columnNumber
     end
   end

end
