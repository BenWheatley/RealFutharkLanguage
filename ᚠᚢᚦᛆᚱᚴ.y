%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare yylex to avoid implicit declaration issues
int yylex(void);

// Declare yyerror to handle syntax errors
void yyerror(const char *s);

int lookup(const char *s); // A stub for identifier lookup
int rune_to_number(const char *s); // Converts a sequence of Futhark runes to a number
%}


%token IDENTIFIER NUMBER EQUAL PLUS

%%

statement:
    assignment
    | expression
    ;

assignment:
    IDENTIFIER EQUAL expression { printf("Assignment: %s = %d\n", $1, $3); }
    ;

expression:
    term
    | expression PLUS term { $$ = $1 + $3; }
    ;

term:
    IDENTIFIER { $$ = lookup($1); }
    | NUMBER { $$ = rune_to_number(yytext); }
    ;

%%

int main(void) {
    return yyparse();
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int lookup(const char *s) {
    // Placeholder function to resolve identifier value
    return 42;
}

int rune_to_number(const char *s) {
    // Logic to convert a sequence of Futhark runes enclosed in '᛭' to a numeric value
    int value = 0;
    s++; // Skip the leading ᛭
    while (*s != '\0' && *s != '᛭') {
        value *= 16; // Shift previous value
        switch (*s) {
            case 'ᚠ': value += 0; break;
            case 'ᚡ': value += 1; break;
            case 'ᚢ': value += 2; break;
            case 'ᚣ': value += 3; break;
            case 'ᚤ': value += 4; break;
            case 'ᚥ': value += 5; break;
            case 'ᚦ': value += 6; break;
            case 'ᚧ': value += 7; break;
            case 'ᚨ': value += 8; break;
            case 'ᚩ': value += 9; break;
            case 'ᚪ': value += 10; break;
            case 'ᚫ': value += 11; break;
            case 'ᚬ': value += 12; break;
            case 'ᚭ': value += 13; break;
            case 'ᚮ': value += 14; break;
            case 'ᚯ': value += 15; break;
            default: return -1; // Invalid rune
        }
        s++;
    }
    return value;
}
