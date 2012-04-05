module SCASM

class Statement
  def assemble io
    fail 'unimplemented'
  end
end

class Instruction < Statement
  def initialize opsym, a, b
    @opsym = opsym
    @a = a
    @b = b
  end

  def assemble io
    if opcode = BASIC_OPCODES[@opsym]
      code_a, imm_a = @a.assemble
      code_b, imm_b = @b.assemble
      code = opcode | (code_a<<4) | (code_b<<10)
      io.write [code, imm_a, imm_b].compact.pack('v*')
    elsif opcode = EXTENDED_OPCODES[@opsym]
      code_a, imm_a = @a.assemble
      fail unless @b == nil
      code = (opcode<<4) | (code_a<<10)
      io.write [code, imm_a].compact.pack('v*')
    else
      fail "unknown opsym #{@opsym.inspect}"
    end
  end

  def to_s
    "%s %s, %s" % [@opsym, @a, @b]
  end
end

class Data < Statement
end

class Label < Statement
end

end
