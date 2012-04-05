require 'test/unit'
require 'scasm/parser'

class ParserTest < Test::Unit::TestCase
  include SCASM

  def setup
  end

  def teardown
  end

  def expect stmts
    @expected = stmts
  end

  def check text
    parser = Parser.new
    result = parser.parse text
    assert_equal @expected, result
  end

  def test_empty
    expect []
    check ''
  end

  def test_instructions
    %w(set add sub mul div mod shl shr and bor xor ife ifn ifg ifb).each do |op|
      expect [Instruction.new(op.to_sym, Register.new(:A), Immediate.new(1))]
      check "#{op} A, 1"
    end

    expect [Instruction.new(:jsr, Register.new(:A), nil)]
    check "jsr A"
  end

  def test_reg
    expect [
      Instruction.new(:set, Register.new(:A), Register.new(:B)),
      Instruction.new(:set, Register.new(:C), Register.new(:X)),
      Instruction.new(:set, Register.new(:Y), Register.new(:Z)),
      Instruction.new(:set, Register.new(:I), Register.new(:J)),
    ]

    check <<-EOS
      set A, B
      set C, X
      set Y, Z
      set I, J
    EOS
  end

  def test_regmem
    expect [
      Instruction.new(:set, RegisterMemory.new(:I), RegisterMemory.new(:J)),
    ]

    check <<-EOS
      set [I], [J]
    EOS
  end

  def test_iregmem
    expect [
      Instruction.new(:set, OffsetRegisterMemory.new(:I, 1), OffsetRegisterMemory.new(:J, 42)),
    ]

    check <<-EOS
      set [1+I], [0x2a+J]
    EOS
  end

  def test_misc
    expect [Instruction.new(:set, Pop.new, Pop.new)]
    check 'set pop, pop'

    expect [Instruction.new(:set, Peek.new, Peek.new)]
    check 'set peek, peek'

    expect [Instruction.new(:set, Push.new, Push.new)]
    check 'set push, push'

    expect [Instruction.new(:set, SP.new, SP.new)]
    check 'set sp, sp'

    expect [Instruction.new(:set, PC.new, PC.new)]
    check 'set pc, pc'

    expect [Instruction.new(:set, O.new, O.new)]
    check 'set o, o'
  end

  def test_imem
    expect [Instruction.new(:set, ImmediateMemory.new(1), ImmediateMemory.new(42))]
    check 'set [1], [0x2a]'
  end

  def test_imm
    expect [Instruction.new(:set, Immediate.new(1), Immediate.new(42))]
    check 'set 1, 0x2a'
  end
end
