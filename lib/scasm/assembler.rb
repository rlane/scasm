require 'stringio'
require 'scasm/isa'
require 'scasm/statement'
require 'scasm/value'

module SCASM

class Assembler < BasicObject
  def initialize
    @stmts = []
  end

  def eval code
    instance_eval code
  end

  def assemble
    io = ::StringIO.new
    @stmts.each { |stmt| stmt.assemble io }
    io.string
  end

  def inst opsym, a, b
    @stmts << Instruction.new(opsym, a, b)
  end

  def reg regsym
    Register.new regsym
  end

  def regmem regsym
    RegisterMemory.new regsym
  end

  def iregmem regsym, imm
    OffsetImmediateMemory.new regsym, imm
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

  # Add a method for each instruction
  BASIC_OPCODES.each do |opsym,opcode|
    define_method(opsym) { |*a| inst opsym, *a }
  end

  # Add a constant for each register
  REGISTERS.each do |regsym,regnum|
    const_set regsym, regsym
  end
end

end
