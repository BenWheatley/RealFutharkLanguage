# RealFutharkLanguage

 ᚦᛆᛐ᛭ᛂᚱ᛭ᛂᛁᚿᚢᚶᛁᛋ᛭ᚴᛆᛚᛚᛆᚧ᛭ᚠᚢᚦᛆᚱᚴ᛭ᛂᚠ᛭ᚦᛆᚧ᛭ᛂᚱ᛭ᚵᛆᛚᛑᚱᛆᚱ᛭ᛋᛂᛘ᛭ᛂᚱᚢ᛭ᚠᛚᚢᛐᛐᛁᚱ᛭ᛆᚠ᛭ᚡᚴᛁᚶᚢᛘ᛭ᛂᚿ᛭ᛂᚠ᛭ᛂᛁᚵᛁ᛭ᚦ᛭ᛂᚱ᛭ᚦᛆᛐ᛭ᚵᛚᛁᛐᚱᛆᚿᛑᛁ᛭ᚠᛁᛚᚱᛅᛐᛐ᛭ᚼᛐᛐ᛭ᛋᛐᛁᚵ᛭ᚠᚿᚴᛋᛁᚿᛆᛚ᛭ᚵᚵᚿ᛭ᛋᛆᛘᚼᛚᛁᚧᛆ᛭ᚱᛆᚧᚦᛚᚢᛐᚢᚿᛆᚱᛐᚢᚶᚢᛘᛚ

(Þat er einungis kallað "futhark" ef það er galdrar sem eru fluttir af víkingum, en ef eigi, þá er þat glitrandi fjölrætt, hátt stig, fúnksjónal, gögn samhliða, raðúthlutunartungumál).

(It's only called "futhark" if it's a spell cast by Vikings, but if not, it's a sparkling polyglot, high-level, functional, data-parallel, serialization language).

A programming language written entirely in Futhark runes. Obviously an April Fool's joke, but it also works because that's the world we live in now.

## Features

- Variables and assignments
- Arithmetic operations (+, -, *, /)
- Comparison operators (==, !=, >, <, >=, <=)
- Control flow (if-else statements, while loops)
- Expression grouping with brackets [ ]
- Proper UTF-8/Unicode handling
- Error reporting with line numbers

## Building

```bash
make
```

This compiles the lexer, parser, and interpreter into an executable called `futhark`.

To rebuild from scratch:
```bash
make rebuild
```

## Running Programs

Execute a .ᚠᚢᚦᛆᚱᚴ file:
```bash
./futhark yourprogram.ᚠᚢᚦᛆᚱᚴ
```

## Running Tests

```bash
make test
```

This runs the automated test suite with 31 tests covering all language features.

## Language Syntax

### Numbers

Numbers are written using runic digits enclosed in ᛫ delimiters:

- `᛫ᚠᚠ᛫` = 0
- `᛫ᚠᚡ᛫` = 1
- `᛫ᚠᚢ᛫` = 2
- `᛫ᚠᚣ᛫` = 3
- `᛫ᚠᚤ᛫` = 4
- `᛫ᚠᚥ᛫` = 5
- `᛫ᚠᚦ᛫` = 6
- `᛫ᚠᚧ᛫` = 7
- `᛫ᚠᚨ᛫` = 8
- `᛫ᚠᚩ᛫` = 9
- `᛫ᚡᚠ᛫` = 10

Larger numbers combine digits: `᛫ᚡᚥ᛫` = 15, `᛫ᚢᚠ᛫` = 20, etc.

### Variables

Variables are single runic characters. Assignment uses `᛬᛬` (double middle-dot):

```
ᛆ ᛬᛬ ᛫ᚠᚥ᛫
```
This assigns 5 to variable `ᛆ`.

### Printing Values

Any expression or variable on its own line prints its result:

```
ᛆ
```
Prints: `Result: 5`

### Arithmetic Operators

- `᛭` - Addition
- `ᛗᚾᚢᛊ` - Subtraction
- `ᛊᛁᚾᚾᚢᛗ` - Multiplication
- `ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ` - Division

Example:
```
ᛆ ᛬᛬ ᛫ᚠᚡ᛫ ᛭ ᛫ᚠᚣ᛫
ᛆ
```
Output: `Result: 4` (1 + 3)

### Expression Grouping

Use brackets `[ ]` for precedence control:

```
[᛫ᚠᚡ᛫ ᛭ ᛫ᚠᚣ᛫] ᛊᛁᚾᚾᚢᛗ ᛫ᚠᚤ᛫
```
Output: `Result: 16` ((1 + 3) * 4)

### Comparison Operators

- `ᛃᚠᚾ` - Equal (==)
- `ᛖᛁᚴᛁ` - Not equal (!=)
- `ᛗᛖᛁᚱ` - Greater than (>)
- `ᛗᛁᚾ` - Less than (<)
- `ᛗᛖᛁᚱ᛬ᛃᚠᚾ` - Greater than or equal (>=)
- `ᛗᛁᚾ᛬ᛃᚠᚾ` - Less than or equal (<=)

Comparisons return 1 (true) or 0 (false):

```
᛫ᚠᚥ᛫ ᛗᛖᛁᚱ ᛫ᚠᚣ᛫
```
Output: `Result: 1` (5 > 3 is true)

### If-Else Statements

Syntax:
```
ᛖᚠ condition
    statements
ᚨᚾᚾᚨᚦ
    statements
ᛖᚾᛞᚨ
```

Keywords:
- `ᛖᚠ` - if
- `ᚨᚾᚾᚨᚦ` - else (optional)
- `ᛖᚾᛞᚨ` - end

Example:
```
ᛆ ᛬᛬ ᛫ᚡᚠ᛫
ᛖᚠ ᛆ ᛗᛖᛁᚱ ᛫ᚠᚥ᛫
    ᛆ ᛬᛬ ᛫ᚡᚥ᛫
ᚨᚾᚾᚨᚦ
    ᛆ ᛬᛬ ᛫ᚡᚠ᛫
ᛖᚾᛞᚨ
ᛆ
```
Output: `Result: 15` (10 > 5, so a = 15)

### While Loops

Syntax:
```
ᚹᚢᛁᛚᛖ condition
    statements
ᛖᚾᛞᚨ
```

Keywords:
- `ᚹᚢᛁᛚᛖ` - while
- `ᛖᚾᛞᚨ` - end

Example (count from 1 to 5):
```
ᛁ ᛬᛬ ᛫ᚠᚡ᛫
ᚹᚢᛁᛚᛖ ᛁ ᛗᛁᚾ᛬ᛃᚠᚾ ᛫ᚠᚦ᛫
    ᛁ
    ᛁ ᛬᛬ ᛁ ᛭ ᛫ᚠᚡ᛫
ᛖᚾᛞᚨ
```
Output:
```
Result: 1
Result: 2
Result: 3
Result: 4
Result: 5
```

## Example Programs

### Factorial Calculation

```
ᚾ ᛬᛬ ᛫ᚠᚥ᛫
ᚱᛖᛋᚢᛚᛏ ᛬᛬ ᛫ᚠᚡ᛫
ᚹᚢᛁᛚᛖ ᚾ ᛗᛖᛁᚱ ᛫ᚠᚡ᛫
    ᚱᛖᛋᚢᛚᛏ ᛬᛬ ᚱᛖᛋᚢᛚᛏ ᛊᛁᚾᚾᚢᛗ ᚾ
    ᚾ ᛬᛬ ᚾ ᛗᚾᚢᛊ ᛫ᚠᚡ᛫
ᛖᚾᛞᚨ
ᚱᛖᛋᚢᛚᛏ
```
Output: `Result: 120` (5! = 120)

### Nested Control Flow

```
ᛆ ᛬᛬ ᛫ᚡᚠ᛫
ᛒ ᛬᛬ ᛫ᚠᚥ᛫
ᚴ ᛬᛬ ᛫ᚠᚠ᛫
ᛖᚠ ᛆ ᛗᛖᛁᚱ ᛫ᚠᚥ᛫
    ᛖᚠ ᛒ ᛗᛖᛁᚱ ᛫ᚠᚣ᛫
        ᚴ ᛬᛬ ᛫ᚡᚠ᛫
    ᚨᚾᚾᚨᚦ
        ᚴ ᛬᛬ ᛫ᚡᚡ᛫
    ᛖᚾᛞᚨ
ᚨᚾᚾᚨᚦ
    ᚴ ᛬᛬ ᛫ᚡᚢ᛫
ᛖᚾᛞᚨ
ᚴ
```
Output: `Result: 10`

### Complex Arithmetic

```
ᛆ ᛬᛬ [[᛫ᚠᚡ᛫ ᛭ ᛫ᚠᚡ᛫] ᛊᛁᚾᚾᚢᛗ ᛫ᚠᚡ᛫] ᛭ ᛫ᚠᚡ᛫
ᛒ ᛬᛬ [᛫ᚡᚠ᛫ ᛗᚾᚢᛊ ᛫ᚠᚥ᛫] ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ ᛫ᚠᚥ᛫
ᛆ ᛭ ᛒ
```
Output: `Result: 4` (((1+1)*1)+1 = 3, (10-5)/5 = 1, 3+1 = 4)

## Error Handling

The interpreter provides helpful error messages:

**Undefined variable:**
```
Error: Undefined variable 'ᛆ' at line 1
```

**Syntax error:**
```
Error: syntax error at line 2, near '᛬'
```

**Division by zero:**
```
Error: Division by zero at line 3
```

## File Extension

Use `.ᚠᚢᚦᛆᚱᚴ` as the file extension for your programs. On most systems, you can create these files using any text editor that supports UTF-8.

## Character Reference

Common runes used in the language:

| Rune | Unicode | Usage |
|------|---------|-------|
| ᛬ | U+16EC | Assignment operator (᛬᛬) |
| ᛫ | U+16EB | Number delimiter |
| ᛭ | U+16ED | Addition operator |
| [ ] | ASCII | Expression grouping |
| ᛆ-ᛰ | U+16A6-U+16B0 | Variable names |

Full Futhark rune range: U+16A0–U+16F8

## Implementation Details

- Lexer: Flex with UTF-8 support
- Parser: Bison with LALR(1) grammar
- Interpreter: C with AST-based evaluation
- Symbol table: Hash map for O(1) variable lookup

## License

This is an April Fool's joke project that became real. Use it however you like.

## Credits

Built as a functioning interpreter for a runic programming language using the Futhark alphabet (ᚠᚢᚦᚨᚱᚴ).
