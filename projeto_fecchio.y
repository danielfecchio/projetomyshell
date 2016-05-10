%{
//Bibliotecas
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

//Arquivos externos
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

//Serve para o programa reconhecer quais são os tipos que ele vai receber de entrada
%union {
int integer;
float pfloat;
char *sval;
}

//tokens definidos no arquivo do flex
%token <pfloat> NUMERO
%token ESQUERDA DIREITA
%token END
%token LS PS KILL MKDIR RMDIR CD TOUCH IFCONFIG START CALCULO QUIT ERROR
%left ADICAO SUBTRACAO MULTIPLICACAO DIVISAO NEGATIVO
%token <sval> STRING
%type <pfloat> Expressao
%start Input
%%

Input: {
char shellName[1024] = "ShellDoDanielFecchio:";
char dir[1024];
getcwd(dir, sizeof(dir));
strcat(shellName,dir);
strcat(shellName,">> ");
printf("%s",shellName);
}

| Input Line {
char shellName[1024] = "ShellDoDanielFecchio:";
char dir[1024];
getcwd(dir, sizeof(dir));
strcat(shellName,dir);
strcat(shellName,">> ");
printf("%s",shellName);
}
;

//implementação da gramática
Line: END
| CALCULO Expressao END { 
printf("Resultado: %f\n", $2); 
}
 
//Lista o conteúdo do diretório atual
| LS END {
system("ls");
}

//Lista todos os processos do usuário
| PS END {
system("ps");
}

//"Mata" o processo de número id
| KILL NUMERO END {
char commandS[1024]; int n; n=(int)$2; snprintf(commandS, 1024, "kill %d", n); system(commandS);
}

//Cria um diretório com o nome id
| MKDIR STRING END {
char cmd[1024]; strcpy(cmd,"/bin/mkdir ");strcat(cmd, $2); system(cmd);
}

//Remove o diretório de nome od
| RMDIR STRING END {
char cmd[1024]; strcpy(cmd,"/bin/rmdir ");strcat(cmd, $2); system(cmd);
}

//Torna o diretório id como atual
| CD STRING END {
int response = 0;
char dir_path[1024];
getcwd(dir_path, sizeof(dir_path));
strcat(dir_path, "/");
strcat(dir_path, $2);
response = chdir(dir_path);
if(response != 0){
printf("Diretirio não encontrado!!!\n");
}
}

//Cria um arquivo com o nome id
| TOUCH STRING END {
char cmd[1024]; strcpy(cmd,"/bin/touch ");strcat(cmd, $2); system(cmd);
}

//Exibe as informações de todas as interfaces de rede do sistema
| IFCONFIG END {
system("ifconfig");
}

//Invoca a execução do programa id
| START STRING END {
char start[1024]; strcpy(start, $2); strcat(start, "&"); system(start);
}

//Encerra o Shell
| QUIT END {
printf("Shell sendo encerrado!!!\n"); exit(0);
}

//Se o usuário digitar algum comando errado aparece a mensagem
|STRING END {
yyerror("Comando inválido") ; return(0);
}
;

//Operações para calcular as operações de adição, subtração, multiplicação e divisão
Expressao:
     	NUMERO { $$ = $1; }
	| Expressao ADICAO Expressao { $$ = $1 + $3; } //operação de adição
	| Expressao SUBTRACAO Expressao { $$ = $1 - $3; } //operação de subtração
	| Expressao MULTIPLICACAO Expressao { $$ = $1 * $3; } //operação de multiplicação
	| Expressao DIVISAO Expressao { if($3)$$ = $1 / $3; else {yyerror("não é possível dividir um número por zero"); return(0);}} //operação de erro caso o usuário coloque qualquer número dividido por zero
	| SUBTRACAO Expressao %prec NEGATIVO { $$ = - $2; } //número negativo
	| ESQUERDA Expressao DIREITA { $$ = $2; } //utilização de parenteses
	;

%%
//função que vai ser chamado se o usuário digitar algo errado
void yyerror(const char *s) {
fprintf(stderr, "Comando invalido. Erro: %s\n", s);
}

//funcao main
int main() {
yyin = stdin;
do {
yyparse();
} while(!feof(yyin));
return 0;
}
