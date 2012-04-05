module SCASM

class Value
  def assemble
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
end

class Pop < Value
  def assemble
    return 0x18
  end
end

class Peek < Value
  def assemble
    return 0x19
  end
end

class Push < Value
  def assemble
    return 0x1a
  end
end

class SP < Value
  def assemble
    return 0x1b
  end
end

class PC < Value
  def assemble
    return 0x1c
  end
end

class O < Value
  def assemble
    return 0x1d
  end
end

class ImmediateMemory < Value
  def initialize imm
    @imm = imm
  end

  def assemble
    return 0x1e, @imm
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
end

end
