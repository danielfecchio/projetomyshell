%{
#define YYSTYPE double
#include "projeto_fecchio.tab.h"
#include <stdlib.h>
%}

white [ \t]+
digito [0-9]
inteiro {digito}+
expoente [eE][+-]?{inteiro}
real {inteiro}("."{inteiro})?{expoente}?

%%

{white} { }
{real} { yylval=atof(yytext); 
 return NUMERO;
}

"+" return ADICAO;
"-" return SUBTRACAO;
"*" return MULTIPLICACAO;
"/" return DIVISAO;
"(" return ESQUERDA;
")" return DIREITA;
"\n" return END;
"ls" return LS;
"ps" return PS;
"quit" return QUIT;
"calculo" return CALCULO;
"kill" return KILL;
