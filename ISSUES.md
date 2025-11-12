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

7. **Incomplete Arithmetic Operations**
   - Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`
   - Issue: Only addition is implemented, missing subtraction, multiplication, division
   - Impact: BNF spec promises full arithmetic but only + works
   - Fix: Add tokens and grammar rules for -, *, / operators

8. **No Expression Grouping**
   - Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`
   - Issue: BNF specifies `[ ]` brackets for grouping, not implemented
   - Impact: Cannot control operator precedence
   - Fix: Add bracket tokens and grouping grammar rule

### Missing Control Flow

9. **No Comparison Operators**
   - Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`
   - Issue: None of the 6 comparison operators from BNF are implemented
   - Impact: Cannot create conditions for if/while statements
   - Fix: Add all comparison operator tokens and condition evaluation

10. **No If-Else Statements**
    - Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`
    - Issue: BNF defines if-else, but no keywords or grammar rules exist
    - Impact: No conditional branching possible
    - Fix: Add keywords ᛖᚠ, ᚨᚾᚾᚨᚦ, ᛖᚾᛞᚨ and implement if-else logic

11. **No While Loops**
    - Files: `ᚠᚢᚦᛆᚱᚴ.lex` and `ᚠᚢᚦᛆᚱᚴ.y`
    - Issue: BNF defines while loops, not implemented
    - Impact: No iteration capability
    - Fix: Add keywords ᚹᚢᛁᛚᛖ, ᛖᚾᛞᚨ and implement loop logic

12. **No AST for Deferred Execution**
    - File: `ᚠᚢᚦᛆᚱᚴ.y`
    - Issue: Current parser executes immediately, cannot support control flow
    - Impact: If-statements and loops need to conditionally execute blocks
    - Fix: Build Abstract Syntax Tree and add evaluation phase

### Usability Issues

13. **No File Input Support**
    - File: `ᚠᚢᚦᛆᚱᚴ.y:51-52`
    - Issue: `main()` only reads from stdin via `yyparse()`
    - Impact: Cannot load programs from files
    - Fix: Add command-line argument for file input

14. **Poor Error Messages**
    - File: `ᚠᚢᚦᛆᚱᚴ.y:55-57`
    - Issue: `yyerror()` only prints generic "Error: ..." message
    - Impact: Difficult to debug programs
    - Fix: Add line numbers, token information, and context

15. **No Test Programs**
    - Issue: No example programs to demonstrate the language
    - Impact: Cannot verify implementation works correctly
    - Fix: Create test files with various language features

16. **No Documentation**
    - Issue: Only BNF spec exists, no usage guide
    - Impact: Users don't know how to write or run programs
    - Fix: Write README with examples and syntax explanation

---

## Implementation Task Breakdown

Each task is scoped to approximately 60-90 minutes for a developer.

### Phase 1: Get It Compiling (Tasks 1-3)

- [ ] **Task 1: Fix immediate compilation errors**
  - Remove duplicate `rune_to_number()` definition
  - Fix char*/wchar_t* type mismatches
  - Verify clean compilation
  - **Time estimate:** 60 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`, `ᚠᚢᚦᛆᚱᚴ.lex`

- [ ] **Task 2: Create Makefile**
  - Add targets for lexer generation (flex)
  - Add targets for parser generation (bison)
  - Add compilation target with proper flags
  - Add clean target
  - **Time estimate:** 45 minutes
  - **Files:** New `Makefile`

- [ ] **Task 3: Implement proper UTF-8/Unicode handling**
  - Research flex Unicode support options
  - Implement consistent UTF-8 byte handling
  - Test with actual runic input
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, possibly `ᚠᚢᚦᛆᚱᚴ.y`

### Phase 2: Core Functionality (Tasks 4-7)

- [ ] **Task 4: Add symbol table for variables**
  - Implement hash map for variable storage
  - Update `lookup()` to retrieve from table
  - Update assignment to store in table
  - Handle undefined variable errors
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`

- [ ] **Task 5: Extend lexer for minus and multiply**
  - Add token patterns for ᛗᚾᚢᛊ and ᛊᛁᚾᚾᚢᛗ
  - Define MINUS and MULTIPLY tokens
  - **Time estimate:** 30 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`

- [ ] **Task 6: Add division operator and parser rules**
  - Add token pattern for ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ
  - Add grammar rules for -, *, / in expression
  - Set proper operator precedence
  - **Time estimate:** 60 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`

- [ ] **Task 7: Implement bracket grouping**
  - Add [ and ] tokens to lexer
  - Add grouping rule to expression grammar
  - Test precedence override
  - **Time estimate:** 45 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`

### Phase 3: Conditions (Tasks 8-9)

- [ ] **Task 8: Add all comparison operators to lexer**
  - Add tokens for all 6 comparison operators with runic patterns
  - Define CMP_EQ, CMP_NEQ, CMP_GT, CMP_LT, CMP_GTE, CMP_LTE
  - **Time estimate:** 60 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`

- [ ] **Task 9: Implement condition evaluation**
  - Add condition grammar rule
  - Add comparison expression evaluation
  - Return boolean results (0 or 1)
  - **Time estimate:** 75 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`

### Phase 4: Control Flow (Tasks 10-13)

- [ ] **Task 10: Implement if-else statements**
  - Add keywords ᛖᚠ, ᚨᚾᚾᚨᚦ, ᛖᚾᛞᚨ to lexer
  - Add if-statement grammar rule
  - Implement basic if-else logic (immediate execution)
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`

- [ ] **Task 11: Implement while loops**
  - Add keyword ᚹᚢᛁᛚᛖ to lexer
  - Add while-loop grammar rule
  - Implement basic loop logic (immediate execution)
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`

- [ ] **Task 12: Create AST data structures**
  - Define node types for all statement/expression kinds
  - Create AST node construction functions
  - Update grammar rules to build AST instead of executing
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`, possibly new `ast.h`

- [ ] **Task 13: Implement AST evaluation**
  - Write recursive evaluator for AST
  - Implement proper control flow (if/while execute child nodes conditionally)
  - Update main() to build then evaluate AST
  - **Time estimate:** 90 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y` or new `interpreter.c`

### Phase 5: Polish (Tasks 14-17)

- [ ] **Task 14: Add file input support**
  - Parse command-line arguments in main()
  - Open file and set yyin
  - Handle file errors gracefully
  - **Time estimate:** 45 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.y`

- [ ] **Task 15: Create test program examples**
  - Write arithmetic test program
  - Write variable assignment test
  - Write conditional test (if-else)
  - Write loop test (while)
  - Write comprehensive program using all features
  - **Time estimate:** 75 minutes
  - **Files:** New test files in runic syntax

- [ ] **Task 16: Add better error reporting**
  - Track line and column numbers in lexer
  - Enhance yyerror() with position information
  - Add error recovery in parser
  - **Time estimate:** 75 minutes
  - **Files:** `ᚠᚢᚦᛆᚱᚴ.lex`, `ᚠᚢᚦᛆᚱᚴ.y`

- [ ] **Task 17: Write usage documentation**
  - Explain what the language is (April Fool's joke)
  - Document syntax with examples
  - Explain how to compile and run programs
  - Add language feature reference
  - **Time estimate:** 60 minutes
  - **Files:** Update `README.md`

---

## Total Estimated Effort

- 17 tasks
- Approximately 1,140 minutes (19 hours)
- 2-3 days of focused development work

## Priority Order

1. **Critical Path:** Tasks 1-3 (must compile first)
2. **High Priority:** Tasks 4, 7 (basic functionality)
3. **Medium Priority:** Tasks 5-6, 8-9 (complete arithmetic and comparisons)
4. **Low Priority:** Tasks 10-13 (control flow - complex but makes it "complete")
5. **Nice to Have:** Tasks 14-17 (polish and documentation)
