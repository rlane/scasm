require 'scasm/isa'
require 'scasm/statement'
require 'scasm/value'

module SCASM

# TODO keep track of line number for error reporting
class Parser
  HEX_RE = /^0[xX][0-9a-fA-F]+$/
  INT_RE = /^\d+$/
  REG_RE = /^[A-Z]+$/
  LABEL_RE = /^[a-z]+$/
  INDIRECT_RE = /^\[.+\]/
  INDIRECT_OFFSET_RE = /^[^+]+\+[^+]+$/

  def clean(line)
    line.gsub(/;.*/, "").gsub(/,/, " ").gsub(/\s+/, " ").strip
  end

  def dehex(token)
    return token.hex.to_s if HEX_RE === token
    token
  end

  def parse_value token
    token = dehex(token)
    sym = token.downcase.to_sym

    if SPECIAL_REGISTERS.member? sym
      return case sym
      when :pop then Pop.new
      when :peek then Peek.new
      when :push then Push.new
      when :sp then SP.new
      when :pc then PC.new
      when :o then O.new
      end
    end

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
        RegisterMemory.new inner.to_sym
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
      fail "No such instruction: #{token}"
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
