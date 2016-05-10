%{
#include <stdio.h>
#define YY_DECL int yylex()
#include "projeto_fecchio.tab.h"
%}
white [ \t]+
digito [0-9]
inteiro {digito}+
expoente [eE][+-]?{inteiro}
real {inteiro}("."{inteiro})?{expoente}?
%%
{white} { }
{real} { yylval.pfloat =atof(yytext);
return NUMERO;
}
"+" return ADICAO;
"-" return SUBTRACAO;
"*" return MULTIPLICACAO;
"/" return DIVISAO;
"(" return ESQUERDA;
")" return DIREITA;
"ls" return LS;
"ps" return PS;
"quit" return QUIT;
"calculo" return CALCULO;
"kill" return KILL;
"mkdir" return MKDIR;
"rmdir" return RMDIR;
"cd" return CD;
"touch" return TOUCH;
"ifconfig" return IFCONFIG;
"start" return START;
[a-zA-Z0-9./\()_]+[.]?[a-zA-Z0-9]* {
yylval.sval = strdup(yytext);
return STRING;
}
"\n" return END;
. return ERROR;
%%
