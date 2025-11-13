%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// Symbol table entry structure
typedef struct symbol {
    char *name;
    int value;
    struct symbol *next;
} Symbol;

// Global symbol table (linked list)
Symbol *symbol_table = NULL;

// Declare yylex and yyerror
int yylex(void);
void yyerror(const char *s);

// Symbol table functions
void store_variable(const char *name, int value);
int lookup(const char *name);
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
%token EQUAL PLUS MINUS MULTIPLY DIVIDE LBRACKET RBRACKET
%token CMP_EQ CMP_NEQ GT LT GTE LTE

%type <num> statement assignment expression term factor condition

%%

program:
    /* empty */
    | program statement
    ;

statement:
    assignment
    | expression { printf("Result: %d\n", $1); }
    | condition { printf("Result: %d\n", $1); }
    ;

assignment:
    IDENTIFIER EQUAL expression {
        store_variable($1, $3);
        printf("Assignment: %s = %d\n", $1, $3);
        free($1);
        $$ = $3;
    }
    ;

expression:
    term { $$ = $1; }
    | expression PLUS term { $$ = $1 + $3; }
    | expression MINUS term { $$ = $1 - $3; }
    ;

term:
    factor { $$ = $1; }
    | term MULTIPLY factor { $$ = $1 * $3; }
    | term DIVIDE factor { $$ = $1 / $3; }
    ;

factor:
    IDENTIFIER { $$ = lookup($1); free($1); }
    | NUMBER { $$ = $1; }
    | LBRACKET expression RBRACKET { $$ = $2; }
    ;

condition:
    expression CMP_EQ expression { $$ = ($1 == $3) ? 1 : 0; }
    | expression CMP_NEQ expression { $$ = ($1 != $3) ? 1 : 0; }
    | expression GT expression { $$ = ($1 > $3) ? 1 : 0; }
    | expression LT expression { $$ = ($1 < $3) ? 1 : 0; }
    | expression GTE expression { $$ = ($1 >= $3) ? 1 : 0; }
    | expression LTE expression { $$ = ($1 <= $3) ? 1 : 0; }
    ;

%%

// External flex variable for input file
extern FILE *yyin;

int main(int argc, char **argv) {
    FILE *input_file = NULL;

    // Check if a file argument was provided
    if (argc > 1) {
        input_file = fopen(argv[1], "r");
        if (input_file == NULL) {
            fprintf(stderr, "Error: Cannot open file '%s': %s\n", argv[1], strerror(errno));
            return 1;
        }
        yyin = input_file;
    }
    // Otherwise, yyin defaults to stdin

    int result = yyparse();

    // Close the file if we opened one
    if (input_file != NULL) {
        fclose(input_file);
    }

    return result;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

/* Store a variable in the symbol table */
void store_variable(const char *name, int value) {
    Symbol *sym = symbol_table;

    // Search for existing variable
    while (sym != NULL) {
        if (strcmp(sym->name, name) == 0) {
            // Variable exists, update value
            sym->value = value;
            return;
        }
        sym = sym->next;
    }

    // Variable doesn't exist, create new entry
    sym = (Symbol *)malloc(sizeof(Symbol));
    if (sym == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }

    sym->name = strdup(name);
    sym->value = value;
    sym->next = symbol_table;
    symbol_table = sym;
}

/* Look up a variable in the symbol table */
int lookup(const char *name) {
    Symbol *sym = symbol_table;

    while (sym != NULL) {
        if (strcmp(sym->name, name) == 0) {
            return sym->value;
        }
        sym = sym->next;
    }

    // Variable not found
    fprintf(stderr, "Error: Undefined variable '%s'\n", name);
    return 0; // Return 0 for undefined variables
}
