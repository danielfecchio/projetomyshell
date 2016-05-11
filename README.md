# projetomyshell

Para compilar o bison é preciso digitar esse comando:
  bison -d projeto_fecchio.y
 
Para compilar o flex é preciso digitar esse comando:
 flex -o projeto_fecchio.lex.c projeto_fecchio.lex
 
Para compilar o programa: 
 gcc -o projeto_fecchio projeto_fecchio.lex.c projeto_fecchio.tab.c -lfl -lm
 
 Para executar o programa: ./projeto_fecchio
