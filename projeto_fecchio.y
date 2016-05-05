%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

%token NUMERO
%token ADICAO SUBTRACAO MULTIPLICACAO DIVISAO
%token ESQUERDA DIREITA
%token END
%token LS PS QUIT CALCULO KILL

%left ADICAO SUBTRACAO
%left MULTIPLICACAO DIVISAO
%left NEGATIVO

%start Input
%%

Input:
     | Input Line
;

Line:
     END
     | CALCULO Expressao END { printf("Resultado: %f\n", $2); } 
     | LS END { system("ls"); }
     | PS END { system("ps"); }
     | QUIT END { printf("Shell sendo encerrado!!!\n"); exit(0); }
;

Expressao:
     	NUMERO { $$ = $1; }
	| Expressao ADICAO Expressao { $$ = $1 + $3; } //operação de adição
	| Expressao SUBTRACAO Expressao { $$ = $1 - $3; } //operação de subtração
	| Expressao MULTIPLICACAO Expressao { $$ = $1 * $3; } //operação de multiplicação
	| Expressao DIVISAO Expressao { if($3)$$ = $1 / $3; else {yyerror("não é possível dividir um número por zero"); return(0);}} //operação de divisão
	| SUBTRACAO Expressao %prec NEGATIVO { $$ = - $2; } //número negativo
	| ESQUERDA Expressao DIREITA { $$ = $2; } //utilização de parenteses
;


%%

//método 
int yyerror(char *s) {
  printf("%s\n", s);
}

int main() {
  if (yyparse())
     fprintf(stderr, "Successful parsing.\n");
  else
     fprintf(stderr, "error found.\n");
}

