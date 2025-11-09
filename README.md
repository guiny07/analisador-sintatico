Projeto de um Analisador Sintático para a disciplina de Compiladores. 

Este projeto é a segunda parte de um projeto anterior de Analisador Léxico. 

# 

A ideia é criar um simulador simples de linguagem de programação, utilizando uma Gramática Livre de Contexto que permita cadeias como:  

- Declaração de variável;
- Comando de seleção;
- Comando de repetição;
- Comando de atribuição;
- Expressões aritméticas/lógicas.

# 
### Ferramentas

O projeto foi desenvolvido utilizando a ferramenta para criar analisador sintático com a linguagem C, o Bison. 

O Bison pode ser instalado, via linha de comando, da seguinte forma: 

`sudo apt install bison`

# 

### Compilando e Executando

O projeto pode ser compilado com a ferramenta Make. Para instalar o Make execute: 

`sudo apt install make`

Daí, apenas execute no terminal, dentro do diretório do projeto: 

`make`

Caso o Make não funcione, execute estes três comandos: 

`bison -d parser.y`
`flex lexer.l`
`gcc parser.tab.c lex.yy.c -o parser -lfl`

E por fim, para a execução do programa, certifique-se de que há o arquivo teste "input.txt" no diretório e execute: 

`./parser input.txt`
