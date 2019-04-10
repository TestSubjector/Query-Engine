%{
#include <stdlib.h>
#include "p2.tab.h"
%}

table Empleado
field idEmpleado|puesto|anho|apellidos|nombre
numbers [0-9]+
operator <|>|=
comma \,
semicolon \;
asterisk \*
stringvalue \".+\"
%%
  {}
<<EOF>> {return EOFF;}
SELECT {return SELECT;}
FROM {return FROM;}
WHERE {return WHERE;}

{table} {
			yylval.valString = strdup(yytext);
			return TABLE;
		}
{field} {
			yylval.valString = strdup(yytext);
			printf("\n Selecting Field -> ");
			printf("%s\n",yytext);
			return FIELD;
		}
{numbers} 	{
				yylval.valString = strdup(yytext);
				return NUMBERS;
			}
{operator} 	{
				yylval.valString = strdup(yytext);
				return OPERATOR;
			}
{comma} {
			yylval.valString = strdup(yytext);
			return COMMA;
		}
{semicolon} 	{
					yylval.valString = strdup(yytext);
					return SEMICOLON;
				}
{asterisk} 	{
				yylval.valString = strdup(yytext);
				return ASTERISK;
			}
{stringvalue} 	{
					yylval.valString = strdup(yytext);
					printf("\n Stringvalue token print ");
					return STRINGVALUE;
				}
. {
	if(!strncmp(yytext," ",1))
	{
		//printf("\n Selected  ->%s<- \n",yytext);
	}
	else
	{
		//printf("\n Select WORD -> %s\n",yytext);
		return WORD;
	}
}
%%
