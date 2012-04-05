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

  def make_word opcode, code_a, code_b
    code = opcode | (code_a<<4) | (code_b<<10)
  end

  def assemble io
    if opcode = BASIC_OPCODES[@opsym]
      code_a, imm_a = @a.assemble
      code_b, imm_b = @b.assemble
      code = make_word opcode, code_a, code_b
      io.write [code, imm_a, imm_b].compact.pack('v*')
    elsif opcode = EXTENDED_OPCODES[@opsym]
      code_a, imm_a = @a.assemble
      fail unless @b == nil
      code = make_word EXT_OPCODE, opcode, code_a
      io.write [code, imm_a].compact.pack('v*')
    else
      fail "unknown opsym #{@opsym.inspect}"
    end
  end

  def to_s
    "%s %s, %s" % [@opsym, @a, @b]
  end

  def == o
    opsym == o.opsym and a == o.a and b == o.b
  end
end

class Data < Statement
  attr_reader :words

  def initialize words
    @words = words
  end

  def assemble io
    io.write @words.pack('v*')
  end

  def to_s
    "data #{@words * ', '}"
  end

  def == o
    words == o.words
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

  def == o
    name == o.name
  end
end

end
