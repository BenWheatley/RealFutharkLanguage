%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>

// Declare yylex and yyerror
int yylex(void);
void yyerror(const char *s);

int lookup(const char *s); // Stub for identifier lookup
int rune_to_number(const wchar_t *s); // Converts a Futhark rune sequence to a number
%}

// Define YYSTYPE union
%union {
    int num;       // Integer values for numbers
    char *id;     // String values for identifiers
}

// Token declarations with types
%token <id> IDENTIFIER
%token <num> NUMBER
%token EQUAL PLUS

%type <num> statement assignment expression term

%%

statement:
    assignment
    | expression { printf("Result: %d\n", $1); }
    ;

assignment:
    IDENTIFIER EQUAL expression { printf("Assignment: %s = %d\n", $1, $3); free($1); }
    ;

expression:
    term { $$ = $1; }
    | expression PLUS term { $$ = $1 + $3; }
    ;

term:
    IDENTIFIER { $$ = lookup($1); free($1); }
    | NUMBER { $$ = $1; }
    ;

%%

int main(void) {
    return yyparse();
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int lookup(const char *s) {
    return 42; // Placeholder
}

int rune_to_number(const wchar_t *s) {
    int value = 0;
    s++; // Skip leading delimiter
    while (*s != L'\0' && *s != L'᛭') {
        value *= 16;
        switch (*s) {
            case L'ᚠ': value += 0; break;
            case L'ᚡ': value += 1; break;
            case L'ᚢ': value += 2; break;
            case L'ᚣ': value += 3; break;
            case L'ᚤ': value += 4; break;
            case L'ᚥ': value += 5; break;
            case L'ᚦ': value += 6; break;
            case L'ᚧ': value += 7; break;
            case L'ᚨ': value += 8; break;
            case L'ᚩ': value += 9; break;
            case L'ᚪ': value += 10; break;
            case L'ᚫ': value += 11; break;
            case L'ᚬ': value += 12; break;
            case L'ᚭ': value += 13; break;
            case L'ᚮ': value += 14; break;
            case L'ᚯ': value += 15; break;
            default: return -1;
        }
        s++;
    }
    return value;
}
