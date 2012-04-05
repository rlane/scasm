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
    expect [
      Instruction.new(:add, Register.new(:A), Immediate.new(1))
    ]

    check <<-EOS
      add A, 1
    EOS
  end
end
