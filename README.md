SCASM
=====

Introduction
------------

SCASM is an assembler for the DCPU-16 architecture used in the game 0x10c.
See the game's [official website](http://0x10c.com/) for details on the
instruction set. This assembler is different and powerful because the
code you write is actually Ruby, meaning you can use all the capabilities
of a high-level programming language to help generate the final machine code.

Installation
------------

    gem install scasm

Example
-------

````ruby
foo = A
bar = B
offset = 42
label "loop"
add [foo, offset], bar
set pc, "loop"
````

See the examples directory for more sample code.

Syntax
------

SCASM input is Ruby code, but you won't need a deep understanding of Ruby to
get started. Simple statements like `add A, 1` work just like you expect. This
section will cover the SCASM-specific syntax.

### Registers

Ruby variables named `A`, `B`, `C`, `X`, `Y`, `Z`, `I`, and `J` are provided to refer to the
processor registers.

### Memory

Memory references are of the form `[register, offset]`. Either `register` or
`offset` can be omitted.

Examples:

* `[A]`
* `[0x100]`
* `[A, 2]`

### Literals

Literal values are just given as integers. Example: `42` or `0x200`.

### Labels

Labels are defined by the `label` statement. To refer to a label, just use its name. For example:

````ruby
label "loop"
add A, 1
set pc, "loop"
````

### Data

Use the `data` statement to put arbitrary words into the binary.

````ruby
label "sin_lookup_table"
data 0, 0x38f6, 0x6f12, 0x9f9c, 0xc825, 0xe6a4, 0xf993, 0xffff
````

### Miscellaneous

These values have the same meaning as in the spec:

* `pop`
* `peek`
* `push`
* `sp`
* `pc`
* `o`

Contributing
------------

Fork the project on GitHub and send me a pull request.
