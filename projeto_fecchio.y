%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
	int integer;
	float pfloat;
	char *sval;
}

//tokens definidos no arquivo do flex
%token <pfloat> NUMERO
%token ADICAO SUBTRACAO MULTIPLICACAO DIVISAO
%token ESQUERDA DIREITA
%token END 
%token LS PS KILL MKDIR RMDIR CD TOUCH IFCONFIG START CALCULO QUIT ERROR
%left ADICAO SUBTRACAO MULTIPLICACAO DIVISAO NEGATIVO
%token <sval> STRING
%start Input
%%

Input: {	
       char shellName[1024] = "FecchioShell:";
       char dir[1024];
       getcwd(dir, sizeof(dir));
       strcat(shellName,dir);
       strcat(shellName,">> ");
       printf("%s",shellName); 
       }
       
       | Input Line {	
               char shellName[1024] = "FecchioShell:";
               char dir[1024];
               getcwd(dir, sizeof(dir));
               strcat(shellName,dir);
               strcat(shellName,">> ");
               printf("%s",shellName); 
               }
	;
	
//implementação da gramática
Line: END
     | LS END { 
          system("ls"); 
          }
     | PS END { 
          system("ps"); 
          }
     | KILL NUMERO END {
            char commandS[1024]; int n; n=(int)$2; snprintf(commandS, 1024, "kill %d", n); system(commandS); 
            }
     | MKDIR STRING END {
            char cmd[1024]; strcpy(cmd,"/bin/mkdir ");strcat(cmd, $2); system(cmd); 
            }
     | RMDIR STRING END {
            char cmd[1024]; strcpy(cmd,"/bin/rmdir ");strcat(cmd, $2); system(cmd); 
            }
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
     | TOUCH STRING END {
             char cmd[1024]; strcpy(cmd,"/bin/touch ");strcat(cmd, $2); system(cmd); 
             }
     | IFCONFIG END {
             system("ifconfig"); 
             }
     | START STRING END {
             char start[1024]; strcpy(start, $2); strcat(start, "&"); system(start);
             }
     | QUIT END { 
            printf("Shell sendo encerrado!!!\n"); exit(0); 
            }
     |STRING END {
             yyerror("Comando invalido") ; return(0);
             }
;

%%

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
