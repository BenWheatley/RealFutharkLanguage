%{
#include "ᚠᚢᚦᛆᚱᚴ.tab.h"  /* Include the Bison-generated header file */
#include <stdlib.h>
#include <string.h>

int rune_to_number(const char *s);
%}

%option 8bit
%option noyywrap
%option yylineno

%%

[ \t\n]+            ;   /* Ignore whitespace */

᛫[ᚠᚡᚢᚣᚤᚥᚦᚧᚨᚩᚪᚫᚬᚭᚮᚯ]+᛫ { /* Matches numbers enclosed by Futhark rune dot-like divider */
    yylval.num = rune_to_number(yytext);
    return NUMBER;
}

"᛬᛬"      { return EQUAL; } /* Matches the "equals" symbol (double dot) */

"᛭"            { return PLUS; } /* Matches the "plus" symbol */

"ᛗᚾᚢᛊ"        { return MINUS; } /* Matches the "minus" operator (mnus) */

"ᛊᛁᚾᚾᚢᛗ"      { return MULTIPLY; } /* Matches the "multiply" operator (sinnum) */

"ᛞᛖᛁᛚᛏ᛬ᛗᛖᚦ"  { return DIVIDE; } /* Matches the "divide" operator (deilt með) */

"["            { return LBRACKET; } /* Left bracket for grouping */

"]"            { return RBRACKET; } /* Right bracket for grouping */

"ᛗᛖᛁᚱ᛬ᛃᚠᚾ"   { return GTE; } /* Greater than or equal (meir jafn) */

"ᛗᛁᚾ᛬ᛃᚠᚾ"    { return LTE; } /* Less than or equal (minn jafn) */

"ᛃᚠᚾ"         { return CMP_EQ; } /* Equal comparison (jafn) */

"ᛖᛁᚴᛁ"        { return CMP_NEQ; } /* Not equal (eigi) */

"ᛗᛖᛁᚱ"        { return GT; } /* Greater than (meir) */

"ᛗᛁᚾ"         { return LT; } /* Less than (minn) */

"ᛖᚠ"           { return IF; } /* If keyword (ef) */

"ᚨᚾᚾᚨᚦ"       { return ELSE; } /* Else keyword (annað) */

"ᚹᚢᛁᛚᛖ"       { return WHILE; } /* While keyword (while) */

"ᛖᚾᛞᚨ"        { return END; } /* End keyword (enda) */

(\341\232[\240-\277]|\341\233[\200-\270])+    { /* Matches identifiers: UTF-8 runes U+16A0-U+16F8 */
    yylval.id = strdup(yytext);
    return IDENTIFIER;
}

%%

/* Convert Futhark rune numbers to their numeric equivalent */
int rune_to_number(const char *s) {
    int value = 0;
    const char *original = s;

    /* Skip the leading rune '᛫' (U+16EB, 3 bytes in UTF-8: E1 9B AB) */
    s += 3;

    /* Process each rune until we hit null terminator or closing '᛫' */
    while (*s != '\0') {
        /* Check if we've hit the closing delimiter (᛫) */
        if ((unsigned char)s[0] == 0xE1 && (unsigned char)s[1] == 0x9B && (unsigned char)s[2] == 0xAB) {
            break;
        }

        value *= 16;

        /* Runes U+16A0-U+16AF encode hex digits 0-F */
        /* UTF-8 encoding: E1 9A [A0-AF] */
        if ((unsigned char)s[0] == 0xE1 && (unsigned char)s[1] == 0x9A) {
            unsigned char third_byte = (unsigned char)s[2];
            if (third_byte >= 0xA0 && third_byte <= 0xAF) {
                value += (third_byte - 0xA0);
                s += 3;
            } else {
                fprintf(stderr, "Lexer error: Invalid rune in number: %s\n", original);
                return -1;  /* Invalid rune */
            }
        } else {
            fprintf(stderr, "Lexer error: Invalid rune in number: %s\n", original);
            return -1;  /* Invalid rune */
        }
    }
    return value;
}
