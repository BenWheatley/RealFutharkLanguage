/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     NUMBER = 259,
     EQUAL = 260,
     PLUS = 261,
     MINUS = 262,
     MULTIPLY = 263,
     LBRACKET = 264,
     RBRACKET = 265,
     CMP_EQ = 266,
     CMP_NEQ = 267,
     GT = 268,
     LT = 269,
     GTE = 270,
     LTE = 271
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define NUMBER 259
#define EQUAL 260
#define PLUS 261
#define MINUS 262
#define MULTIPLY 263
#define LBRACKET 264
#define RBRACKET 265
#define CMP_EQ 266
#define CMP_NEQ 267
#define GT 268
#define LT 269
#define GTE 270
#define LTE 271




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 27 "ᚠᚢᚦᛆᚱᚴ.y"
{
    int num;       // Integer values for numbers
    char *id;     // String values for identifiers
}
/* Line 1529 of yacc.c.  */
#line 86 "ᚠᚢᚦᛆᚱᚴ.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

