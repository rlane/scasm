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
end
