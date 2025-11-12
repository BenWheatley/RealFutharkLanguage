%{
#include "ᚠᚢᚦᛆᚱᚴ.tab.h"  /* Include the Bison-generated header file */
#include <stdlib.h>
#include <string.h>

int rune_to_number(const char *s);
%}

%%

[ \t\n]+            ;   /* Ignore whitespace */

\u16EB[\u16A0-\u16AF]+\u16EB { /* Matches numbers enclosed by Futhark rune dot-like divider */
    yylval.num = rune_to_number(yytext);
    return NUMBER;
}

"\u16EC\u16EC"      { return EQUAL; } /* Matches the "equals" symbol (kinda ::) */

"\u16ED"            { return PLUS; } /* Matches the "plus" symbol (kinda +) */

[\u16A0-\u16F8]+    { /* Matches identifiers composed of Futhark runes */
    yylval.id = strdup(yytext);
    return IDENTIFIER;
}

%%

int yywrap() {
    return 1;
}

/* Convert Futhark rune numbers to their numeric equivalent */
int rune_to_number(const char *s) {
    int value = 0;
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
                return -1;  /* Invalid rune */
            }
        } else {
            return -1;  /* Invalid rune */
        }
    }
    return value;
}
