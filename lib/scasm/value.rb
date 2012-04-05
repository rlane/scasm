module SCASM

class Value
  def assemble
    fail "not implemented"
  end

  def to_s
    fail "not implemented"
  end
end

class Register < Value
  attr_reader :regsym

  def initialize regsym
    fail "invalid register #{regsym.inspect}" unless REGISTERS.member? regsym
    @regsym = regsym
  end

  def assemble
    return REGISTERS[@regsym]
  end

  def to_s
    "reg(#@regsym)"
  end

  def == o
    self.class == o.class and regsym == o.regsym
  end
end

class RegisterMemory < Value
  attr_reader :regsym

  def initialize regsym
    fail "invalid register #{regsym.inspect}" unless REGISTERS.member? regsym
    @regsym = regsym
  end

  def assemble
    return INDIRECT + REGISTERS[@regsym]
  end

  def to_s
    "regmem(#@regsym)"
  end

  def == o
    self.class == o.class and regsym == o.regsym
  end
end

class OffsetRegisterMemory < Value
  attr_reader :regsym, :imm

  def initialize regsym, imm
    fail "invalid register #{regsym.inspect}" unless REGISTERS.member? regsym
    @regsym = regsym
    @imm = imm
  end

  def assemble
    return (INDIRECT_OFFSET + REGISTERS[@regsym]), @imm
  end

  def to_s
    "iregmem(#@regsym, #@imm)"
  end

  def == o
    self.class == o.class and regsym == o.regsym and imm == o.imm
  end
end

class Pop < Value
  def assemble
    return SPECIAL_REGISTERS[:pop]
  end

  def to_s
    'pop'
  end

  def == o
    self.class == o.class
  end
end

class Peek < Value
  def assemble
    return SPECIAL_REGISTERS[:peek]
  end

  def to_s
    'peek'
  end

  def == o
    self.class == o.class
  end
end

class Push < Value
  def assemble
    return SPECIAL_REGISTERS[:push]
  end

  def to_s
    'push'
  end

  def == o
    self.class == o.class
  end
end

class SP < Value
  def assemble
    return SPECIAL_REGISTERS[:sp]
  end

  def to_s
    'sp'
  end

  def == o
    self.class == o.class
  end
end

class PC < Value
  def assemble
    return SPECIAL_REGISTERS[:pc]
  end

  def to_s
    'pc'
  end

  def == o
    self.class == o.class
  end
end

class O < Value
  def assemble
    return SPECIAL_REGISTERS[:o]
  end

  def to_s
    'o'
  end

  def == o
    self.class == o.class
  end
end

class ImmediateMemory < Value
  attr_reader :imm

  def initialize imm
    @imm = imm
  end

  def assemble
    return INDIRECT_NEXT, @imm
  end

  def to_s
    "imem(#@imm)"
  end

  def == o
    self.class == o.class and imm == o.imm
  end
end

class Immediate < Value
  attr_reader :imm

  def initialize imm
    @imm = imm
  end

  def assemble
    if @imm <= NEXT
      return LITERAL + @imm
    else
      return NEXT, @imm
    end
  end

  def to_s
    "imm(#@imm)"
  end

  def value
    @imm
  end

  def == o
    self.class == o.class and imm == o.imm
  end
end

class ImmediateLabel < Value
  attr_reader :name

  def initialize name
    @name = name
    @imm = nil
  end

  def resolve imm
    fail if @imm
    @imm = imm
  end

  def assemble
    #fail unless @imm
    return NEXT, (@imm||0) # HACK
  end

  def to_s
    "l(#{@name.inspect})"
  end

  def == o
    self.class == o.class and name == o.imm
  end
end

end
