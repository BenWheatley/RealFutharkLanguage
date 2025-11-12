%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare yylex and yyerror
int yylex(void);
void yyerror(const char *s);

int lookup(const char *s); // Stub for identifier lookup
int rune_to_number(const char *s); // Converts a Futhark rune sequence to a number
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
