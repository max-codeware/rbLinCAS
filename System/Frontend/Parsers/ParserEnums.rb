#! /usr/bin/env ruby

class MathFunctEnum < Enum

 private
   enum_attr :LOG
   enum_attr :EXP
   enum_attr :TAN
   enum_attr :ATAN
   enum_attr :COS
   enum_attr :ACOS
   enum_attr :SIN
   enum_attr :ASIN
   enum_attr :SQRT
   
   List = []
     
   mfe = MathFunctEnum.new
   self.public_instance_methods(false).each do |method|
     m = self.public_instance_method(method)
     m = m.bind(mfe)
     List << m.call
   end
   mfe = nil
     
   
 public
 
   def include?(_f)
     List.include? _f
   end

end
MathFunct = MathFunctEnum.new


class ProductOp < Enum

  private

    enum_attr :STAR
    enum_attr :SLASH
    enum_attr :BSLASH
    enum_attr :MOD
    
    List = []
    
    p_op = ProductOp.new   
    self.public_instance_methods(false).each do |method|
      m = self.public_instance_method(method)
      m = m.bind(p_op)
      List << m.call
    end
    p_op = nil
    
  public
  
    def include?(_o)
      return List.include? _o
    end  
    
end
ProdOp = ProductOp.new


class SumOp < Enum

  private
  
    enum_attr :PLUS
    enum_attr :MINUS
    
    List = []
    
    s_op = SumOp.new   
    self.public_instance_methods(false).each do |method|
      m = self.public_instance_method(method)
      m = m.bind(s_op)
      List << m.call
    end
    s_op = nil
    
  public
  
    def include?(_o)
      return List.include? _o
    end  
      
end
AddOp = SumOp.new


class OpOpTranslator < Enum

  private
  
    enum_attr :STAR,       ICodeNType.MULT
    enum_attr :SLASH,      ICodeNType.FDIV
    enum_attr :BSLASH,     ICodeNType.IDIV
    enum_attr :MOD,        ICodeNType.MOD
    enum_attr :PLUS,       ICodeNType.ADD
    enum_attr :MINUS,      ICodeNType.SUB
    enum_attr :GREATER,    ICodeNType.GR
    enum_attr :SMALLER,    ICodeNType.SM
    enum_attr :GREATER_EQ, ICodeNType.GE
    enum_attr :SMALLER_EQ, ICodeNType.SE
    enum_attr :NOT_EQ,     ICodeNType.NE
    enum_attr :EQ_EQ,      ICodeNType.EQ
    
    List = {}
    
    p_op_op = OpOpTranslator.new
    self.public_instance_methods(false).each do |method|
      m = self.public_instance_method(method)
      m = m.bind(p_op_op)
      List[method] = m.call
    end
    p_op_op = nil
    
  public
  
    def getICType(_o)
      return List[_o] if self.include? _o
      nil
    end
  
    def include?(_o)
      List.keys.include? _o
    end

end
OpOpTr = OpOpTranslator.new


class BooleanOpTr < Enum

  private
    
    enum_attr :AND,        ICodeNType.AND
    enum_attr :OR,         ICodeNType.OR
    # enum_attr :NOT,        ICodeNType.NOT
    
    List = {}
    
    b_op = BooleanOpTr.new
    self.public_instance_methods(false).each do |method|
      m = self.public_instance_method(method)
      m = m.bind(b_op)
      List[method] = m.call
    end
    b_op = nil
    
  public
  
    def getICType(_o)
      return List[_o] if self.include? _o
      nil
    end
  
    def include?(_o)
      List.keys.include? _o
    end

end
BoolOpTr = BooleanOpTr.new







