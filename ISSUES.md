# RealFutharkLanguage - Issues and Implementation Plan

## Project Overview

This is an April Fool's joke programming language that uses Futhark runes (Old Norse/Viking alphabet) for all syntax. The language is designed to be a functional programming language written entirely in runic characters (Unicode range U+16A0-U+16F8).

### Intended Features (per BNF specification)
- Variables and assignments using `᛬᛬` (double dot) as equals
- Arithmetic operations: addition (ᛈᛚᛊ), subtraction (ᛗᚾᚢᛊ), multiplication (ᛊᛁᚾᚾᚢᛗ), division (ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ)
- Hexadecimal numbers enclosed in ᛫ delimiters, using runes ᚠ-ᚯ for digits 0-F
- Bracket grouping `[ ]` for expression precedence
- If-else statements with keywords: ᛖᚠ (if), ᚨᚾᚾᚨᚦ (else), ᛖᚾᛞᚨ (end)
- While loops with keywords: ᚹᚢᛁᛚᛖ (while), ᛖᚾᛞᚨ (end)
- Comparison operators: == (ᛖᚱ᛬ᛃöᚠᚾ), != (ᛖᚱ᛬óᛃöᚠᚾ᛬ᚹᛁᚦ), >, <, >=, <=

---

## Current Problems

### Critical Compilation Errors

1. ✓ ~~**Duplicate Symbol Error**~~
   - ~~File: `ᚠᚢᚦᛆᚱᚴ.y:63` and `ᚠᚢᚦᛆᚱᚴ.lex:35`~~
   - ~~Issue: `rune_to_number()` function is defined in both files~~
   - ~~Impact: Cannot compile/link the program~~
   - ~~Fix: Remove one definition, keep only the declaration in one file~~
   - **FIXED:** Removed duplicate implementation from `ᚠᚢᚦᛆᚱᚴ.y`, kept only in `ᚠᚢᚦᛆᚱᚴ.lex`

2. ✓ ~~**Type Mismatch Error**~~
   - ~~File: `ᚠᚢᚦᛆᚱᚴ.lex:24`~~
   - ~~Issue: Assigning `wchar_t*` to `char*` in `yylval.id = wcsdup((wchar_t *)yytext)`~~
   - ~~Impact: Incompatible pointer types warning, will cause runtime issues~~
   - ~~Fix: Proper handling of wide characters throughout the codebase~~
   - **FIXED:** Changed all `wchar_t*` to `char*` for UTF-8 handling. Updated `rune_to_number()` to work with UTF-8 byte sequences instead of wide characters. Now uses `strdup(yytext)` instead of `wcsdup()`. Compiles cleanly with no warnings.

3. ✓ ~~**Missing Build System**~~
   - ~~Issue: No Makefile or build script~~
   - ~~Impact: Manual compilation is error-prone and inconsistent~~
   - ~~Fix: Create Makefile with proper flex/bison targets~~
   - **FIXED:** Created comprehensive Makefile with targets for `all` (build), `clean`, `rebuild`, `install`, and `help`. Properly handles flex/bison code generation, compilation with warnings enabled (-Wall -Wextra), and linking. Includes dependency tracking so only modified files are rebuilt.

### Unicode and Character Encoding Issues

4. ✓ ~~**Improper Unicode Handling**~~
   - ~~File: `ᚠᚢᚦᛆᚱᚴ.lex`~~
   - ~~Issue: Using standard flex without proper UTF-8/Unicode support~~
   - ~~Impact: Runic characters may not be recognized correctly~~
   - ~~Fix: Add `%option unicode` or handle multibyte UTF-8 encoding properly~~
   - **FIXED:** Replaced `\uXXXX` escape sequences with actual Unicode rune characters in lexer patterns. Added `%option 8bit` and `%option noyywrap` for proper UTF-8 byte handling. All patterns now correctly match: numbers (᛫[runes]᛫), operators (᛬᛬ for equals, ᛭ for plus), and identifiers ([ᚠ-ᛸ]+). Tested successfully with rune input.

5. ✓ ~~**Inconsistent Character Types**~~
   - ~~Files: Throughout lexer and parser~~
   - ~~Issue: Mixing `char*`, `wchar_t*`, and assuming single-byte characters~~
   - ~~Impact: Runes are multi-byte UTF-8, will cause parsing failures~~
   - ~~Fix: Consistent use of UTF-8 byte sequences or wide character handling~~
   - **FIXED:** Already resolved in issue #2 (Type Mismatch Error). All code now consistently uses `char*` with UTF-8 byte sequences.

### Missing Core Functionality

6. ✓ ~~**No Variable Storage**~~
   - ~~File: `ᚠᚢᚦᛆᚱᚴ.y:59-61`~~
   - ~~Issue: `lookup()` function returns placeholder value 42~~
   - ~~Impact: Variables cannot be stored or retrieved~~
   - ~~Fix: Implement symbol table (hash map) to store variable assignments~~
   - **FIXED:** Implemented linked-list symbol table with `store_variable()` and `lookup()` functions. Variables can now be stored, retrieved, and reassigned. Undefined variables return 0 with error message. Added `program` rule to parser to accept multiple statements. Tested successfully with multiple variables and expressions.

7. ✓ ~~**Incomplete Arithmetic Operations**~~
   - ~~Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`~~
   - ~~Issue: Only addition is implemented, missing subtraction, multiplication, division~~
   - ~~Impact: BNF spec promises full arithmetic but only + works~~
   - ~~Fix: Add tokens and grammar rules for -, *, / operators~~
   - **FIXED:** Implemented all four arithmetic operators: `᛭` (+), `ᛗᚾᚢᛊ` (-), `ᛊᛁᚾᚾᚢᛗ` (*), `ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ` (/). Restructured grammar with proper precedence: expression (+ -), term (* /), factor (atoms). Multiplication and division have higher precedence than addition and subtraction. Brackets override precedence. Integer division truncates. All tests pass with correct precedence: 2+3*4=14, (2+3)*4=20, 32+8*3-16/4=52.

8. ✓ ~~**No Expression Grouping**~~
   - ~~Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`~~
   - ~~Issue: BNF specifies `[ ]` brackets for grouping, not implemented~~
   - ~~Impact: Cannot control operator precedence~~
   - ~~Fix: Add bracket tokens and grouping grammar rule~~
   - **FIXED:** Added LBRACKET and RBRACKET tokens to lexer. Added grammar rule `term: LBRACKET expression RBRACKET` to parser. Brackets now properly control evaluation order and can be nested. Tested successfully with simple, nested, and complex expressions.

### Missing Control Flow

9. ✓ ~~**No Comparison Operators**~~
   - ~~Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`~~
   - ~~Issue: None of the 6 comparison operators from BNF are implemented~~
   - ~~Impact: Cannot create conditions for if/while statements~~
   - ~~Fix: Add all comparison operator tokens and condition evaluation~~
   - **FIXED:** Implemented all six comparison operators using short Icelandic words in runes: `ᛃᚠᚾ` (==), `ᛖᛁᚴᛁ` (!=), `ᛗᛖᛁᚱ` (>), `ᛗᛁᚾ` (<), `ᛗᛖᛁᚱ᛬ᛃᚠᚾ` (>=), `ᛗᛁᚾ᛬ᛃᚠᚾ` (<=). Added `condition` grammar rule that evaluates comparisons and returns 1 for true, 0 for false. All operators tested successfully with numbers, variables, and expressions.

10. ✓ ~~**No If-Else Statements**~~
    - ~~Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`~~
    - ~~Issue: BNF defines if-else, but no keywords or grammar rules exist~~
    - ~~Impact: No conditional branching possible~~
    - ~~Fix: Add keywords ᛖᚠ, ᚨᚾᚾᚨᚦ, ᛖᚾᛞᚨ and implement if-else logic~~
    - **FIXED:** Implemented complete if-else statement support. Added keywords to lexer: `ᛖᚠ` (if), `ᚨᚾᚾᚨᚦ` (else), `ᛖᚾᛞᚨ` (end). Created Abstract Syntax Tree (AST) data structures with node types for numbers, identifiers, binary operations, assignments, if statements, and statement blocks. Rewrote parser grammar to build AST instead of immediate execution. Implemented AST evaluation with conditional execution support. Fixed identifier lexer pattern to properly capture full 3-byte UTF-8 rune sequences using octal escapes `(\341\232[\240-\277]|\341\233[\200-\270])+`. Both if-only and if-else branches tested successfully with correct conditional execution.

11. ✓ ~~**No While Loops**~~
    - ~~Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`~~
    - ~~Issue: BNF defines while loops, not implemented~~
    - ~~Impact: No iteration capability~~
    - ~~Fix: Add keywords ᚹᚢᛁᛚᛖ, ᛖᚾᛞᚨ and implement loop logic~~
    - **FIXED:** Implemented complete while loop support. Added `ᚹᚢᛁᛚᛖ` (while) keyword to lexer, sharing the existing `ᛖᚾᛞᚨ` (end) keyword. Created AST_WHILE node type with condition and body fields. Added while_statement grammar rule and integrated with statement_list for loop body. Implemented loop evaluation in evaluate_ast that repeatedly evaluates condition and executes body until condition becomes false. Added proper memory cleanup in free_ast. Tested successfully with simple loops, nested if-inside-while, and accumulator patterns. All previous tests continue to pass.

12. ✓ ~~**No AST for Deferred Execution**~~
    - ~~File: `ᚠᚢᚦᛆᚱᚴ.y`~~
    - ~~Issue: Current parser executes immediately, cannot support control flow~~
    - ~~Impact: If-statements and loops need to conditionally execute blocks~~
    - ~~Fix: Build Abstract Syntax Tree and add evaluation phase~~
    - **FIXED:** Implemented as part of if-else statement implementation (issue #10). See that issue for full details on AST structure, node types, and evaluation phase.

### Usability Issues

13. ✓ ~~**No File Input Support**~~
    - ~~File: `ᚠᚢᚦᛆᚱᚴ.y:51-52`~~
    - ~~Issue: `main()` only reads from stdin via `yyparse()`~~
    - ~~Impact: Cannot load programs from files~~
    - ~~Fix: Add command-line argument for file input~~
    - **FIXED:** Modified `main(int argc, char **argv)` to accept file path as command-line argument. If argument provided, opens file and sets `yyin`. Proper error handling with `strerror(errno)` for file open failures. Falls back to stdin if no argument provided. Tested successfully with `.ᚠᚢᚦᛆᚱᚴ` files.

14. ✓ ~~**Poor Error Messages**~~
    - ~~File: `ᚠᚢᚦᛆᚱᚴ.y:55-57`~~
    - ~~Issue: `yyerror()` only prints generic "Error: ..." message~~
    - ~~Impact: Difficult to debug programs~~
    - ~~Fix: Add line numbers, token information, and context~~
    - **FIXED:** Implemented comprehensive error reporting system. Added `%option yylineno` to lexer for automatic line number tracking. Added `current_filename` global to track source file name (shows "<stdin>" for interactive input). Updated `yyerror()` to display errors in standard format: `filename:line: error: message`. Added "near token" hints that show the problematic token with UTF-8 rune support. Updated runtime errors (undefined variables, division by zero) to include filename context. All error messages now provide clear location information for debugging. Tested with syntax errors, undefined variables, and division by zero - all show proper file:line context.

15. ✓ ~~**No Test Programs**~~
    - ~~Issue: No example programs to demonstrate the language~~
    - ~~Impact: Cannot verify implementation works correctly~~
    - ~~Fix: Create test files with various language features~~
    - **FIXED:** Created comprehensive test suite with 12 test files covering all language features: `simple.ᚠᚢᚦᛆᚱᚴ` (arithmetic operations), `test.ᚠᚢᚦᛆᚱᚴ` (variable multiplication), `if_simple.ᚠᚢᚦᛆᚱᚴ` (if statement), `if_else_test.ᚠᚢᚦᛆᚱᚴ` (if-else), `comprehensive_test.ᚠᚢᚦᛆᚱᚴ` (all features), `while_test.ᚠᚢᚦᛆᚱᚴ` (while loop), `nested_test.ᚠᚢᚦᛆᚱᚴ` (nested if inside while), `factorial.ᚠᚢᚦᛆᚱᚴ` (factorial calculation), and 4 error test files demonstrating undefined variables, syntax errors, division by zero, and other error conditions. All tests pass successfully.

16. **No Documentation**
    - Issue: Only BNF spec exists, no usage guide
    - Impact: Users don't know how to write or run programs
    - Fix: Write README with examples and syntax explanation

---

## Implementation Task Breakdown

Each task is scoped to approximately 60-90 minutes for a developer.

### Phase 1: Get It Compiling (Tasks 1-3)

- [x] **Task 1: Fix immediate compilation errors** ✓
  - Remove duplicate `rune_to_number()` definition
  - Fix char*/wchar_t* type mismatches
  - Verify clean compilation
  - **Time estimate:** 60 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`, `ᚠᚢᚦᛆᚱᚴ.lex`
  - **COMPLETED:** See issues #1 and #2

- [x] **Task 2: Create Makefile** ✓
  - Add targets for lexer generation (flex)
  - Add targets for parser generation (bison)
  - Add compilation target with proper flags
  - Add clean target
  - **Time estimate:** 45 minutes
  - **Files:** New `Makefile`
  - **COMPLETED:** See issue #3

- [x] **Task 3: Implement proper UTF-8/Unicode handling** ✓
  - Research flex Unicode support options
  - Implement consistent UTF-8 byte handling
  - Test with actual runic input
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, possibly `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issues #4 and #5

### Phase 2: Core Functionality (Tasks 4-7)

- [x] **Task 4: Add symbol table for variables** ✓
  - Implement hash map for variable storage
  - Update `lookup()` to retrieve from table
  - Update assignment to store in table
  - Handle undefined variable errors
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #6. Tested with `test.ᚠᚢᚦᛆᚱᚴ` and `comprehensive_test.ᚠᚢᚦᛆᚱᚴ`

- [x] **Task 5: Extend lexer for minus and multiply** ✓
  - Add token patterns for ᛗᚾᚢᛊ and ᛊᛁᚾᚾᚢᛗ
  - Define MINUS and MULTIPLY tokens
  - **Time estimate:** 30 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`
  - **COMPLETED:** See issue #7

- [x] **Task 6: Add division operator and parser rules** ✓
  - Add token pattern for ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ
  - Add grammar rules for -, *, / in expression
  - Set proper operator precedence
  - **Time estimate:** 60 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #7. Tested with `simple.ᚠᚢᚦᛆᚱᚴ` showing correct precedence

- [x] **Task 7: Implement bracket grouping** ✓
  - Add [ and ] tokens to lexer
  - Add grouping rule to expression grammar
  - Test precedence override
  - **Time estimate:** 45 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #8. Tested with `comprehensive_test.ᚠᚢᚦᛆᚱᚴ`

### Phase 3: Conditions (Tasks 8-9)

- [x] **Task 8: Add all comparison operators to lexer** ✓
  - Add tokens for all 6 comparison operators with runic patterns
  - Define CMP_EQ, CMP_NEQ, CMP_GT, CMP_LT, CMP_GTE, CMP_LTE
  - **Time estimate:** 60 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`
  - **COMPLETED:** See issue #9. Used Icelandic words: ᛃᚠᚾ (==), ᛖᛁᚴᛁ (!=), etc.

- [x] **Task 9: Implement condition evaluation** ✓
  - Add condition grammar rule
  - Add comparison expression evaluation
  - Return boolean results (0 or 1)
  - **Time estimate:** 75 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #9. Tested with `if_simple.ᚠᚢᚦᛆᚱᚴ` and `if_else_test.ᚠᚢᚦᛆᚱᚴ`

### Phase 4: Control Flow (Tasks 10-13)

- [x] **Task 10: Implement if-else statements** ✓
  - Add keywords ᛖᚠ, ᚨᚾᚾᚨᚦ, ᛖᚾᛞᚨ to lexer
  - Add if-statement grammar rule
  - Implement basic if-else logic (immediate execution)
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #10. Tested with `if_simple.ᚠᚢᚦᛆᚱᚴ`, `if_else_test.ᚠᚢᚦᛆᚱᚴ`, and `comprehensive_test.ᚠᚢᚦᛆᚱᚴ`

- [x] **Task 11: Implement while loops** ✓
  - Add keyword ᚹᚢᛁᛚᛖ to lexer
  - Add while-loop grammar rule
  - Implement basic loop logic (immediate execution)
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #11. Tested with `while_test.ᚠᚢᚦᛆᚱᚴ`, `nested_test.ᚠᚢᚦᛆᚱᚴ`, and `factorial.ᚠᚢᚦᛆᚱᚴ`

- [x] **Task 12: Create AST data structures** ✓
  - Define node types for all statement/expression kinds
  - Create AST node construction functions
  - Update grammar rules to build AST instead of executing
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`, possibly new `ast.h`
  - **COMPLETED:** See issue #12. AST implementation in `ᚠᚢᚦᛆᚱᚴ.y` with 8 node types

- [x] **Task 13: Implement AST evaluation** ✓
  - Write recursive evaluator for AST
  - Implement proper control flow (if/while execute child nodes conditionally)
  - Update main() to build then evaluate AST
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y` or new `interpreter.c`
  - **COMPLETED:** See issue #12. `evaluate_ast()` function handles all control flow

### Phase 5: Polish (Tasks 14-17)

- [x] **Task 14: Add file input support** ✓
  - Parse command-line arguments in main()
  - Open file and set yyin
  - Handle file errors gracefully
  - **Time estimate:** 45 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #13. All test files run from command line: `./futhark file.ᚠᚢᚦᛆᚱᚴ`

- [x] **Task 15: Create test program examples** ✓
  - Write arithmetic test program
  - Write variable assignment test
  - Write conditional test (if-else)
  - Write loop test (while)
  - Write comprehensive program using all features
  - **Time estimate:** 75 minutes
  - **Files:** New test files in runic syntax
  - **COMPLETED:** See issue #15. Created 12 test files demonstrating all features

- [x] **Task 16: Add better error reporting** ✓
  - Track line and column numbers in lexer
  - Enhance yyerror() with position information
  - Add error recovery in parser
  - **Time estimate:** 75 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`
  - **COMPLETED:** See issue #14. Tested with `error_test*.ᚠᚢᚦᛆᚱᚴ` files showing proper file:line context

- [ ] **Task 17: Write usage documentation**
  - Explain what the language is (April Fool's joke)
  - Document syntax with examples
  - Explain how to compile and run programs
  - Add language feature reference
  - **Time estimate:** 60 minutes
  - **Files:** Update `README.md`
  - **STATUS:** Only remaining task

---

## Total Estimated Effort

- 17 tasks total
- ✓ **16 tasks completed** (94%)
- ❌ **1 task remaining** (6%)
- Approximately 1,140 minutes estimated (19 hours)
- Actual completion: 1,080 minutes of estimated work done

## Completion Status by Phase

1. ✓ **Phase 1: Get It Compiling** (Tasks 1-3) - 100% COMPLETE
2. ✓ **Phase 2: Core Functionality** (Tasks 4-7) - 100% COMPLETE
3. ✓ **Phase 3: Conditions** (Tasks 8-9) - 100% COMPLETE
4. ✓ **Phase 4: Control Flow** (Tasks 10-13) - 100% COMPLETE
5. ⚠️ **Phase 5: Polish** (Tasks 14-17) - 75% COMPLETE (only documentation remaining)

## Original Priority Order

1. ✓ **Critical Path:** Tasks 1-3 (must compile first) - DONE
2. ✓ **High Priority:** Tasks 4, 7 (basic functionality) - DONE
3. ✓ **Medium Priority:** Tasks 5-6, 8-9 (complete arithmetic and comparisons) - DONE
4. ✓ **Low Priority:** Tasks 10-13 (control flow - complex but makes it "complete") - DONE
5. ⚠️ **Nice to Have:** Tasks 14-17 (polish and documentation) - 3/4 DONE

## What Works Now

The RealFutharkLanguage interpreter is **fully functional** with all core features implemented:

✓ Variables and assignments
✓ All arithmetic operators (+, -, *, /) with correct precedence
✓ Bracket grouping for expression control
✓ All 6 comparison operators (==, !=, >, <, >=, <=)
✓ If-else conditional statements
✓ While loops
✓ File input from .ᚠᚢᚦᛆᚱᚴ files
✓ Comprehensive error reporting with file:line information
✓ 12 test programs demonstrating all features
✓ Makefile build system

**Only remaining:** User documentation (README.md)
