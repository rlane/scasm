require 'stringio'

module SCASM

class Statement
  attr_accessor :addr

  def assemble io
    fail 'unimplemented'
  end

  def to_s
    fail 'unimplemented'
  end

  # XXX HACK
  def length
    io = StringIO.new
    assemble io
    io.length/2
  end
end

class Instruction < Statement
  attr_reader :opsym, :a, :b
  attr_writer :b # for disassembler

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
  def initialize words
    @words = words
  end

  def assemble io
    io.write @words.pack('v*')
  end

  def to_s
    "data #{@words * ', '}"
  end
end

class Label < Statement
  attr_reader :name

  def initialize name
    @name = name
  end

  def assemble io
    # nop
  end

  def to_s
    "label #{@name.inspect}"
  end
end

end
