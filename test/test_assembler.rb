require 'test/unit'
require 'scasm/assembler'

class AssemblerTest < Test::Unit::TestCase
  def setup
    @expected = nil
  end

  def teardown
  end

  def expect words
    @expected = words
  end

  def check code
    as = SCASM::Assembler.new
    as.eval code
    result = as.assemble
    result_words = result.unpack('v*')
    assert_equal @expected, result_words
  end

  def test_empty
    expect []
    check ''
  end

  def test_reg
    expect [
      0x0401,
      0x0c21,
      0x1441,
      0x1c61,
    ]

    check <<-EOS
      set reg(A), reg(B)
      set reg(C), reg(X)
      set reg(Y), reg(Z)
      set reg(I), reg(J)
    EOS
  end

  def test_regmem
    expect [0x0cb1]
    check "set regmem(X), reg(X)"
  end

  def test_iregmem
    expect [0x0d31, 0x002a]
    check 'set iregmem(X, 42), reg(X)'
  end

  def test_misc
    expect [0x6181]
    check 'set pop, pop'

    expect [0x6591]
    check 'set peek, peek'

    expect [0x69a1]
    check 'set push, push'

    expect [0x6db1]
    check 'set sp, sp'

    expect [0x71c1]
    check 'set pc, pc'

    expect [0x75d1]
    check 'set o, o'
  end

  def test_imem
    expect [0x7801, 0x1000]
    check 'set reg(A), imem(0x1000)'
  end

  def test_imm
    expect [0xfc01]
    check "set reg(A), imm(31)"

    expect [0x7c01, 0x0020]
    check "set reg(A), imm(32)"

    expect [0x7df1, 0xffff, 0x0020]
    check "set imm(65535), imm(32)"
  end
end
