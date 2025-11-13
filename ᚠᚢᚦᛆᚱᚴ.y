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

// AST node types
typedef enum {
    AST_NUMBER,
    AST_IDENTIFIER,
    AST_BINARY_OP,
    AST_CONDITION,
    AST_ASSIGNMENT,
    AST_IF,
    AST_WHILE,
    AST_BLOCK
} ASTNodeType;

// AST node structure
typedef struct ASTNode {
    ASTNodeType type;
    union {
        int number;
        char *identifier;
        struct {
            char op;  // '+', '-', '*', '/', or comparison
            struct ASTNode *left;
            struct ASTNode *right;
        } binary;
        struct {
            char *var_name;
            struct ASTNode *expr;
        } assignment;
        struct {
            struct ASTNode *condition;
            struct ASTNode *then_block;
            struct ASTNode *else_block;
        } if_stmt;
        struct {
            struct ASTNode *condition;
            struct ASTNode *body;
        } while_stmt;
        struct {
            struct ASTNode **statements;
            int count;
            int capacity;
        } block;
    } data;
} ASTNode;

// Declare yylex and yyerror
int yylex(void);
void yyerror(const char *s);
extern int yylineno;  // Line number from lexer
extern char *yytext;  // Current token text from lexer

// Global for current filename
const char *current_filename = NULL;

// Symbol table functions
void store_variable(const char *name, int value);
int lookup(const char *name);
int rune_to_number(const char *s);

// AST functions
ASTNode* create_number_node(int value);
ASTNode* create_identifier_node(char *name);
ASTNode* create_binary_op_node(char op, ASTNode *left, ASTNode *right);
ASTNode* create_assignment_node(char *var_name, ASTNode *expr);
ASTNode* create_if_node(ASTNode *condition, ASTNode *then_block, ASTNode *else_block);
ASTNode* create_while_node(ASTNode *condition, ASTNode *body);
ASTNode* create_block_node();
void block_add_statement(ASTNode *block, ASTNode *stmt);
int evaluate_ast(ASTNode *node);
void free_ast(ASTNode *node);
%}

// Define YYSTYPE union
%union {
    int num;       // Integer values for numbers
    char *id;     // String values for identifiers
    struct ASTNode *ast;  // AST node pointers
}

// Token declarations with types
%token <id> IDENTIFIER
%token <num> NUMBER
%token EQUAL PLUS MINUS MULTIPLY DIVIDE LBRACKET RBRACKET
%token CMP_EQ CMP_NEQ GT LT GTE LTE
%token IF ELSE WHILE END

%type <ast> statement assignment expression term factor condition if_statement while_statement statement_list

%%

program:
    /* empty */
    | program statement {
        if ($2) {
            int result = evaluate_ast($2);
            if ($2->type != AST_ASSIGNMENT && $2->type != AST_IF && $2->type != AST_WHILE) {
                printf("Result: %d\n", result);
            }
            free_ast($2);
        }
    }
    ;

statement:
    assignment
    | expression
    | condition
    | if_statement
    | while_statement
    ;

assignment:
    IDENTIFIER EQUAL expression {
        $$ = create_assignment_node($1, $3);
    }
    ;

expression:
    term { $$ = $1; }
    | expression PLUS term { $$ = create_binary_op_node('+', $1, $3); }
    | expression MINUS term { $$ = create_binary_op_node('-', $1, $3); }
    ;

term:
    factor { $$ = $1; }
    | term MULTIPLY factor { $$ = create_binary_op_node('*', $1, $3); }
    | term DIVIDE factor { $$ = create_binary_op_node('/', $1, $3); }
    ;

factor:
    IDENTIFIER { $$ = create_identifier_node($1); }
    | NUMBER { $$ = create_number_node($1); }
    | LBRACKET expression RBRACKET { $$ = $2; }
    ;

condition:
    expression CMP_EQ expression { $$ = create_binary_op_node('=', $1, $3); }
    | expression CMP_NEQ expression { $$ = create_binary_op_node('!', $1, $3); }
    | expression GT expression { $$ = create_binary_op_node('>', $1, $3); }
    | expression LT expression { $$ = create_binary_op_node('<', $1, $3); }
    | expression GTE expression { $$ = create_binary_op_node('G', $1, $3); }
    | expression LTE expression { $$ = create_binary_op_node('L', $1, $3); }
    ;

if_statement:
    IF condition statement_list END {
        $$ = create_if_node($2, $3, NULL);
    }
    | IF condition statement_list ELSE statement_list END {
        $$ = create_if_node($2, $3, $5);
    }
    ;

while_statement:
    WHILE condition statement_list END {
        $$ = create_while_node($2, $3);
    }
    ;

statement_list:
    statement {
        $$ = create_block_node();
        block_add_statement($$, $1);
    }
    | statement_list statement {
        block_add_statement($1, $2);
        $$ = $1;
    }
    ;

%%

// External flex variable for input file
extern FILE *yyin;

int main(int argc, char **argv) {
    FILE *input_file = NULL;

    // Check if a file argument was provided
    if (argc > 1) {
        current_filename = argv[1];
        input_file = fopen(argv[1], "r");
        if (input_file == NULL) {
            fprintf(stderr, "Error: Cannot open file '%s': %s\n", argv[1], strerror(errno));
            return 1;
        }
        yyin = input_file;
    } else {
        current_filename = "<stdin>";
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
    if (current_filename) {
        fprintf(stderr, "%s:%d: error: %s\n", current_filename, yylineno, s);
    } else {
        fprintf(stderr, "line %d: error: %s\n", yylineno, s);
    }

    // Add hint about nearby token if available
    if (yytext && yytext[0] != '\0') {
        // For UTF-8 runes, show hex bytes
        if ((unsigned char)yytext[0] >= 0x80) {
            fprintf(stderr, "  near token: ");
            for (int i = 0; i < 12 && yytext[i] != '\0'; i++) {
                if (i > 0 && (unsigned char)yytext[i] >= 0x80 &&
                    ((unsigned char)yytext[i] & 0xC0) != 0x80) {
                    fprintf(stderr, " ");
                }
                fprintf(stderr, "%c", yytext[i]);
            }
            fprintf(stderr, "\n");
        } else {
            fprintf(stderr, "  near token: '%s'\n", yytext);
        }
    }
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

    // Variable not found - provide helpful error message
    if (current_filename) {
        fprintf(stderr, "%s: runtime error: Undefined variable '", current_filename);
    } else {
        fprintf(stderr, "runtime error: Undefined variable '");
    }

    // Print variable name (runes)
    for (int i = 0; name[i] != '\0'; i++) {
        fprintf(stderr, "%c", name[i]);
    }
    fprintf(stderr, "'\n");

    return 0; // Return 0 for undefined variables
}

/* AST Creation Functions */

ASTNode* create_number_node(int value) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_NUMBER;
    node->data.number = value;
    return node;
}

ASTNode* create_identifier_node(char *name) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_IDENTIFIER;
    node->data.identifier = name;  // Takes ownership of the string
    return node;
}

ASTNode* create_binary_op_node(char op, ASTNode *left, ASTNode *right) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_BINARY_OP;
    node->data.binary.op = op;
    node->data.binary.left = left;
    node->data.binary.right = right;
    return node;
}

ASTNode* create_assignment_node(char *var_name, ASTNode *expr) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_ASSIGNMENT;
    node->data.assignment.var_name = var_name;  // Takes ownership
    node->data.assignment.expr = expr;
    return node;
}

ASTNode* create_if_node(ASTNode *condition, ASTNode *then_block, ASTNode *else_block) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_IF;
    node->data.if_stmt.condition = condition;
    node->data.if_stmt.then_block = then_block;
    node->data.if_stmt.else_block = else_block;
    return node;
}

ASTNode* create_while_node(ASTNode *condition, ASTNode *body) {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_WHILE;
    node->data.while_stmt.condition = condition;
    node->data.while_stmt.body = body;
    return node;
}

ASTNode* create_block_node() {
    ASTNode *node = (ASTNode *)malloc(sizeof(ASTNode));
    if (node == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    node->type = AST_BLOCK;
    node->data.block.capacity = 4;  // Start with capacity for 4 statements
    node->data.block.count = 0;
    node->data.block.statements = (ASTNode **)malloc(sizeof(ASTNode *) * node->data.block.capacity);
    if (node->data.block.statements == NULL) {
        fprintf(stderr, "Error: Out of memory\n");
        exit(1);
    }
    return node;
}

void block_add_statement(ASTNode *block, ASTNode *stmt) {
    if (block->type != AST_BLOCK) {
        fprintf(stderr, "Error: Attempting to add statement to non-block node\n");
        return;
    }

    // Expand capacity if needed
    if (block->data.block.count >= block->data.block.capacity) {
        block->data.block.capacity *= 2;
        block->data.block.statements = (ASTNode **)realloc(
            block->data.block.statements,
            sizeof(ASTNode *) * block->data.block.capacity
        );
        if (block->data.block.statements == NULL) {
            fprintf(stderr, "Error: Out of memory\n");
            exit(1);
        }
    }

    block->data.block.statements[block->data.block.count++] = stmt;
}

/* AST Evaluation Function */

int evaluate_ast(ASTNode *node) {
    if (node == NULL) {
        return 0;
    }

    switch (node->type) {
        case AST_NUMBER:
            return node->data.number;

        case AST_IDENTIFIER:
            return lookup(node->data.identifier);

        case AST_BINARY_OP: {
            int left = evaluate_ast(node->data.binary.left);
            int right = evaluate_ast(node->data.binary.right);

            switch (node->data.binary.op) {
                case '+': return left + right;
                case '-': return left - right;
                case '*': return left * right;
                case '/':
                    if (right == 0) {
                        if (current_filename) {
                            fprintf(stderr, "%s: runtime error: Division by zero\n", current_filename);
                        } else {
                            fprintf(stderr, "runtime error: Division by zero\n");
                        }
                        return 0;
                    }
                    return left / right;
                case '=': return left == right ? 1 : 0;  // CMP_EQ
                case '!': return left != right ? 1 : 0;  // CMP_NEQ
                case '>': return left > right ? 1 : 0;   // GT
                case '<': return left < right ? 1 : 0;   // LT
                case 'G': return left >= right ? 1 : 0;  // GTE
                case 'L': return left <= right ? 1 : 0;  // LTE
                default:
                    fprintf(stderr, "Error: Unknown operator '%c'\n", node->data.binary.op);
                    return 0;
            }
        }

        case AST_ASSIGNMENT: {
            int value = evaluate_ast(node->data.assignment.expr);
            store_variable(node->data.assignment.var_name, value);
            return value;
        }

        case AST_IF: {
            int condition = evaluate_ast(node->data.if_stmt.condition);
            if (condition) {
                return evaluate_ast(node->data.if_stmt.then_block);
            } else if (node->data.if_stmt.else_block != NULL) {
                return evaluate_ast(node->data.if_stmt.else_block);
            }
            return 0;
        }

        case AST_WHILE: {
            int result = 0;
            while (evaluate_ast(node->data.while_stmt.condition)) {
                result = evaluate_ast(node->data.while_stmt.body);
            }
            return result;
        }

        case AST_BLOCK: {
            int result = 0;
            for (int i = 0; i < node->data.block.count; i++) {
                result = evaluate_ast(node->data.block.statements[i]);
            }
            return result;
        }

        default:
            fprintf(stderr, "Error: Unknown AST node type\n");
            return 0;
    }
}

/* Free AST memory */

void free_ast(ASTNode *node) {
    if (node == NULL) {
        return;
    }

    switch (node->type) {
        case AST_NUMBER:
            break;

        case AST_IDENTIFIER:
            free(node->data.identifier);
            break;

        case AST_BINARY_OP:
        case AST_CONDITION:  // Conditions are stored as binary ops
            free_ast(node->data.binary.left);
            free_ast(node->data.binary.right);
            break;

        case AST_ASSIGNMENT:
            free(node->data.assignment.var_name);
            free_ast(node->data.assignment.expr);
            break;

        case AST_IF:
            free_ast(node->data.if_stmt.condition);
            free_ast(node->data.if_stmt.then_block);
            free_ast(node->data.if_stmt.else_block);
            break;

        case AST_WHILE:
            free_ast(node->data.while_stmt.condition);
            free_ast(node->data.while_stmt.body);
            break;

        case AST_BLOCK:
            for (int i = 0; i < node->data.block.count; i++) {
                free_ast(node->data.block.statements[i]);
            }
            free(node->data.block.statements);
            break;
    }

    free(node);
}
