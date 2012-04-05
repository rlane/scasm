module SCASM

EXT_OPCODE = 0

INDIRECT = 0x08
INDIRECT_OFFSET = 0x10
INDIRECT_NEXT = 0x1e
NEXT = 0x1f
LITERAL = 0x20

BASIC_OPCODES = {
  :ext => 0x0,
  :set => 0x1,
  :add => 0x2,
  :sub => 0x3,
  :mul => 0x4,
  :div => 0x5,
  :mod => 0x6,
  :shl => 0x7,
  :shr => 0x8,
  :and => 0x9,
  :bor => 0xa,
  :xor => 0xb,
  :ife => 0xc,
  :ifn => 0xd,
  :ifg => 0xe,
  :ifb => 0xf,
}

EXTENDED_OPCODES = {
  :jsr => 0x01,
}

REGISTERS = {
  :A => 0,
  :B => 1,
  :C => 2,
  :X => 3,
  :Y => 4,
  :Z => 5,
  :I => 6,
  :J => 7,
}

SPECIAL_REGISTERS = {
  :pop => 0x18,
  :peek => 0x19,
  :push => 0x1a,
  :sp => 0x1b,
  :pc => 0x1c,
  :o => 0x1d,
}

end
