%{
#include "ᚠᚢᚦᛆᚱᚴ.tab.h"  /* Include the Bison-generated header file */
#include <wchar.h>         /* Include support for wide characters */
#include <stdlib.h>
#include <string.h>

int rune_to_number(const wchar_t *s);
%}

%%

[ \t\n]+            ;   /* Ignore whitespace */

\u16EB[\u16A0-\u16AF]+\u16EB { /* Matches numbers enclosed by Futhark rune dot-like divider */
    yylval.num = rune_to_number((wchar_t *)yytext);
    return NUMBER; 
}

"\u16EC\u16EC"      { return EQUAL; } /* Matches the "equals" symbol (kinda ::) */

"\u16ED"            { return PLUS; } /* Matches the "plus" symbol (kinda +) */

[\u16A0-\u16F8]+    { /* Matches identifiers composed of Futhark runes */
    yylval.id = wcsdup((wchar_t *)yytext);
    return IDENTIFIER; 
}

%%

int yywrap() {
    return 1;
}

/* Convert Futhark rune numbers to their numeric equivalent */
int rune_to_number(const wchar_t *s) {
    int value = 0;
    s++;  /* Skip the leading rune '᛭' */
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
            default: return -1;  /* Invalid rune */
        }
        s++;
    }
    return value;
}
