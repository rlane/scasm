require 'stringio'
require 'scasm/isa'
require 'scasm/statement'
require 'scasm/value'

module SCASM

class Assembler < BasicObject
  def initialize
    @stmts = []
    @relocations = []
  end

  def eval code
    instance_eval code
  end

  def assemble
    resolve_labels
    io = ::StringIO.new
    @stmts.each { |stmt| stmt.assemble io }
    io.string
  end

  def inst opsym, a, b
    a = parse_value a
    b = parse_value b
    @stmts << Instruction.new(opsym, a, b)
  end

  def label name
    ::Kernel.raise "label names must be strings" unless name.is_a? ::String
    @stmts << Label.new(name)
  end

  def reg regsym
    Register.new regsym
  end

  def regmem regsym
    RegisterMemory.new regsym
  end

  def iregmem regsym, imm
    OffsetRegisterMemory.new regsym, imm
  end

  def pop
    Pop.new
  end

  def peek
    Peek.new
  end

  def push
    Push.new
  end

  def sp
    SP.new
  end

  def pc
    PC.new
  end

  def o
    O.new
  end

  def imem imm
    ImmediateMemory.new imm
  end

  def imm imm
    Immediate.new imm
  end

  def l name
    ::Kernel.raise "label names must be strings" unless name.is_a? ::String
    ImmediateLabel.new(name).tap { |x| @relocations << x }
  end

  def data *words
    @stmts << Data.new(words)
  end

  # Add a method for each instruction
  BASIC_OPCODES.each do |opsym,opcode|
    define_method(opsym) { |a,b| inst opsym, a, b }
  end

  EXTENDED_OPCODES.each do |opsym,opcode|
    define_method(opsym) { |a| inst opsym, a, nil }
  end

  # Add a constant for each register
  REGISTERS.each do |regsym,regnum|
    const_set regsym, regsym
  end

  ## Pseudoinstructions

  def jmp label
    set pc, label
  end

  def ret
    set pc, pop
  end

private
  
  def resolve_labels
    label_addrs = {}

    addr = 0
    @stmts.each do |stmt|
      if stmt.is_a? Label
        label_addrs[stmt.name] = addr
      end
      addr += stmt.length
    end

    @relocations.each do |x|
      addr = label_addrs[x.name] or ::Kernel.raise "undefined label #{x.name.inspect}"
      x.resolve addr
    end
  end

  # Shorter notation for values
  def parse_value x
    case x
    when Value, ::NilClass
      x
    when ::Array
      x1, x2, = x
      if x1.is_a? ::Symbol and x2 == nil
        # [reg]
        RegisterMemory.new x1
      elsif x1.is_a? ::Symbol and x2.is_a? ::Integer
        # [reg, imm]
        OffsetRegisterMemory.new x1, x2
      elsif x1.is_a? ::Integer
        # [imm]
        ImmediateMemory.new x1
      else
        ::Kernel.fail "invalid memory access syntax"
      end
    when ::Symbol
      # register
      Register.new x
    when ::String
      # label
      ImmediateLabel.new(x).tap { |v| @relocations << v }
    when ::Integer
      # immediate
      Immediate.new x
    else
      ::Kernel.raise "unexpected value class #{x.class}"
    end
  end
end

end
