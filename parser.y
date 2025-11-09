%{
    
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    extern int yylineno;
    void yyerror(const char *s);    
    
%}

%locations

// Declaração dos tokens, correspondendo ao lexer.l 
%token IF ELSE WHILE FOR
%token INT FLOAT_T CHAR_T STRING_T RETURN 
%token ID INTEGER FLOAT CHAR STRING

%token SUM_OP SUB_OP MULT_OP DIV_OP
%token ASSIGN_OP
%token EQ_OP NE_OP GT_OP LT_OP GE_OP LE_OP 
%token AND_OP OR_OP NOT_OP
%token BIT_AND_OP BIT_OR_OP

// Precedência e associatividade dos operadores
%left OR_OP BIT_OR_OP
%left AND_OP BIT_AND_OP
%left EQ_OP NE_OP
%left GT_OP LT_OP GE_OP LE_OP
%left SUM_OP SUB_OP
%left MULT_OP DIV_OP
%right NOT_OP
%right ASSIGN_OP

// Sem associatividade 
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%start programa 

%%

// Regras da gramática
programa
    : lista_comandos
    ;

lista_comandos
    : lista_comandos comando
    | comando
    ;

comando: 
     declaracao ';'             { printf("Variable declaration at line %d \n", yylineno); }
    | atribuicao ';'            { printf("Assign at line %d \n", yylineno); }
    | selecao                   
    | repeticao                 
    | chamada_funcao ';'        { printf("Function call at line %d \n", yylineno); }
    | declaracao_funcao         
    | expressao ';'             { printf("Expression statement at line %d\n", yylineno); }
    | RETURN expressao ';'      { printf("return of expression at line %d \n", yylineno); }
    ;

declaracao:
     tipo lista_ids
    ;

tipo:
     INT
    | FLOAT_T
    | CHAR_T
    | STRING_T
    ;

lista_ids:
     lista_ids ',' ID
    | lista_ids ',' ID ASSIGN_OP expressao
    | ID
    | ID ASSIGN_OP expressao
    ;

atribuicao:
     ID ASSIGN_OP expressao
    ;

selecao:
     IF '(' expressao ')' bloco %prec LOWER_THAN_ELSE           { printf("if structure at line %d \n", @1.first_line); }   
    | IF '(' expressao ')' bloco ELSE bloco                     { printf("if/else structure at line %d \n", @1.first_line); }
    ;

repeticao:
     WHILE '(' expressao ')' bloco                              { printf("while loop at line %d \n", @1.first_line); } 
    ;

bloco:
     '{' lista_comandos '}'
    | comando
    ;

chamada_funcao:
     ID '(' lista_argumentos ')'
    ;

lista_argumentos:
    
    | lista_argumentos_nao_vazia
    ;

lista_argumentos_nao_vazia:
     expressao
    | lista_argumentos_nao_vazia ',' expressao
    ;

declaracao_funcao:
     tipo ID '(' lista_parametros ')' bloco           { printf("Function definition at line %d\n", @1.first_line); }
    | tipo ID '(' lista_parametros ')' ';'            { printf("Function prototype at line %d\n", yylineno); }
    ;

lista_parametros:
     
    | lista_parametros_nao_vazia
    ;

lista_parametros_nao_vazia:
     tipo ID 
    | lista_parametros_nao_vazia ',' tipo ID
    ;

expressao
    : expressao SUM_OP expressao
    | expressao SUB_OP expressao 
    | expressao MULT_OP expressao
    | expressao DIV_OP expressao
    | expressao EQ_OP expressao
    | expressao NE_OP expressao
    | expressao GT_OP expressao
    | expressao LT_OP expressao
    | expressao GE_OP expressao
    | expressao LE_OP expressao
    | expressao AND_OP expressao
    | expressao OR_OP expressao
    | expressao BIT_AND_OP expressao
    | expressao BIT_OR_OP expressao
    | NOT_OP expressao
    | '(' expressao ')'
    | ID
    | INTEGER
    | FLOAT
    | CHAR
    | STRING
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntatic error: %s at line %d\n", s, yylineno);
}

int main(int argc, char **argv)
{
    if(argc < 2)
    {
        fprintf(stderr, "Too few arguments, please type: %s file.txt\n", argv[0]);
        return 1;
    }

    extern FILE *yyin;
    yyin = fopen(argv[1], "r");
    if(!yyin)
    {
        perror("Can't open file...");
        return 1;
    }

    yyparse();

    fclose(yyin);
    return 0;
}