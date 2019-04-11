/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

#ifndef YY_YY_P2_TAB_H_INCLUDED
# define YY_YY_P2_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    GET = 258,
    FROM = 259,
    WHERE = 260,
    AND = 261,
    OR = 262,
    FIELD = 263,
    TABLE = 264,
    OPERATOR = 265,
    EOFF = 266,
    NUMBERS = 267,
    COMMA = 268,
    SEMICOLON = 269,
    ASTERISK = 270,
    STRINGVALUE = 271,
    WORD = 272,
    SINGLEQUOTES = 273
  };
#endif
/* Tokens.  */
#define GET 258
#define FROM 259
#define WHERE 260
#define AND 261
#define OR 262
#define FIELD 263
#define TABLE 264
#define OPERATOR 265
#define EOFF 266
#define NUMBERS 267
#define COMMA 268
#define SEMICOLON 269
#define ASTERISK 270
#define STRINGVALUE 271
#define WORD 272
#define SINGLEQUOTES 273

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 29 "p2.y" /* yacc.c:1909  */

	int valInt;
	char * valString;

#line 95 "p2.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_P2_TAB_H_INCLUDED  */
