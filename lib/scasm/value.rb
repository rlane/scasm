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
end

class RegisterMemory < Value
  def initialize regsym
    fail "invalid register #{regsym.inspect}" unless REGISTERS.member? regsym
    @regsym = regsym
  end

  def assemble
    return 0x08 + REGISTERS[@regsym]
  end

  def to_s
    "regmem(#@regsym)"
  end
end

class OffsetRegisterMemory < Value
  def initialize regsym, imm
    fail "invalid register #{regsym.inspect}" unless REGISTERS.member? regsym
    @regsym = regsym
    @imm = imm
  end

  def assemble
    return (0x10 + REGISTERS[@regsym]), @imm
  end

  def to_s
    "iregmem(#@regsym, #@imm)"
  end
end

class Pop < Value
  def assemble
    return 0x18
  end

  def to_s
    'pop'
  end
end

class Peek < Value
  def assemble
    return 0x19
  end

  def to_s
    'peek'
  end
end

class Push < Value
  def assemble
    return 0x1a
  end

  def to_s
    'push'
  end
end

class SP < Value
  def assemble
    return 0x1b
  end

  def to_s
    'sp'
  end
end

class PC < Value
  def assemble
    return 0x1c
  end

  def to_s
    'pc'
  end
end

class O < Value
  def assemble
    return 0x1d
  end

  def to_s
    'o'
  end
end

class ImmediateMemory < Value
  def initialize imm
    @imm = imm
  end

  def assemble
    return 0x1e, @imm
  end

  def to_s
    "imem(#@imm)"
  end
end

class Immediate < Value
  def initialize imm
    @imm = imm
  end

  def assemble
    if @imm <= 0x1f
      return 0x20 + @imm
    else
      return 0x1f, @imm
    end
  end

  def to_s
    "imm(#@imm)"
  end
end

end
