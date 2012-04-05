require 'scasm/isa'
require 'scasm/statement'
require 'scasm/value'

module SCASM

# TODO keep track of line number for error reporting
class Parser
  def self.declare(map, start, string)
    count = start
    string.split(" ").each do |token|
      map[token] = count
      count += 1
    end
  end

  HEX_RE = /^0x[0-9a-fA-F]+$/
  INT_RE = /^\d+$/
  REG_RE = /^[A-Z]+$/
  LABEL_RE = /^[a-z]+$/
  INDIRECT_RE = /^\[.+\]/
  INDIRECT_OFFSET_RE = /^[^+]+\+[^+]+$/

  EXT_PREFIX = 0

  INDIRECT = 0x08
  INDIRECT_OFFSET = 0x10
  INDIRECT_NEXT = 0x1e
  NEXT = 0x1f
  LITERAL = 0x20

  INSTRUCTIONS = {}
  EXTENDED_INSTRUCTIONS = {}
  VALUES = {}

  declare(INSTRUCTIONS, 1, "SET ADD SUB MUL DIV MOD SHL SHR AND BOR XOR IFE IFN IFG IFB")
  declare(EXTENDED_INSTRUCTIONS, 1, "JSR")
  declare(VALUES, 0, "A B C X Y Z I J")
  declare(VALUES, 0x18, "POP PEEK PUSH SP PC O")

  def initialize
  end

  def clean(line)
    line.gsub(/;.*/, "").gsub(/,/, " ").gsub(/\s+/, " ").strip
  end

  def dehex(token)
    return token.hex.to_s if HEX_RE === token
    token
  end

  def parse_value token
    token = dehex(token)

    case token
    when INT_RE
      Immediate.new token.to_i
    when REG_RE
      Register.new token.to_sym
    when LABEL_RE
      ImmediateLabel.new token
    when INDIRECT_RE
      inner = dehex(token[1..-2])
      case inner
      when INT_RE
        ImmediateMemory.new inner.to_i
      when REG_RE
        Register.new inner.to_sym
      when LABEL_RE
        ImmediateLabel.new inner
      when INDIRECT_OFFSET_RE
        offset, reg = inner.split("+").map{|x| x.strip }
        offset = dehex(offset)
        fail "Malformed indirect offset value #{inner}" unless INT_RE === offset && REG_RE === reg
        value = offset.to_i
        OffsetRegisterMemory.new reg.to_sym, value
      else
        fail "Unrecognized value #{token}"
      end
    end
  end

  def parse_statement tokens
    token = tokens.shift

    if BASIC_OPCODES.member? token.to_sym
      a = parse_value tokens.shift
      b = parse_value tokens.shift
      Instruction.new token.to_sym, a, b
    elsif EXTENDED_OPCODES.member? token.to_sym
      a = parse_value tokens.shift
      Instruction.new token.to_sym, a, nil
    else
      fail "No such instruction: #{opsym}"
    end
  end

  def parse text
    stmts = []
    text.each_line do |line|
      cleaned = clean(line)
      next if cleaned.empty?

      tokens = cleaned.split(/\s/)
      #fail "Wrong number of tokens") unless (2..4) === tokens.size

      if tokens[0].start_with?(":")
        stmts << Label.new(tokens.shift[1..-1])
      end

      stmts << parse_statement(tokens)
    end
    stmts
  end
end

end
