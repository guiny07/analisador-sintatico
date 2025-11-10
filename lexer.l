%option noyywrap
%option yylineno
%option noinput nounput


DIGIT                                   [0-9]
LETTER                                  [a-zA-Z]
INVALID_ID                              ({DIGIT})(({LETTER}|{DIGIT}|_)*)
ID                                      ({LETTER}|_)(({LETTER}|{DIGIT}|_)*) 
FLOAT                                   {INTEGER}\.{INTEGER}+([eE][-+]?{DIGIT}+)?
INTEGER                                 {DIGIT}+
CHAR                                    \'([^\'\n]|\\.)\' 
STRING                                  \"([^\"\\]|\\.)*\" 

%{
    #include <stdio.h>  
    #include "parser.tab.h"
    extern FILE *yyin;
%}



%%

"if"                                    { return IF; }
"else"                                  { return ELSE; }
"while"                                 { return WHILE; }
"int"                                   { return INT; }
"float"                                 { return FLOAT_T; }
"char"                                  { return CHAR_T; }
"string"                                { return STRING_T;}
"return"                                { return RETURN; }


{FLOAT}                                 { return FLOAT; }
{INTEGER}                               { return INTEGER; }

{CHAR}                                  { return CHAR; }
{STRING}                                { return STRING; }

{INVALID_ID}                            { printf("ERROR: INVALID_ID(%s) AT LINE %d\n", yytext, yylineno); }
{ID}                                    { return ID; }

"+"                                     { return SUM_OP; }                                     
"-"                                     { return SUB_OP; }
"*"                                     { return MULT_OP; }
"/"                                     { return DIV_OP; }
"!="                                    { return NE_OP; }
"!"                                     { return NOT_OP; }
"&&"                                    { return AND_OP; }
"||"                                    { return OR_OP; }
"&"                                     { return BIT_AND_OP; }
"|"                                     { return BIT_OR_OP; }
"=="                                    { return EQ_OP; }
"="                                     { return ASSIGN_OP; }
">="                                    { return GE_OP; }
"<="                                    { return LE_OP; }
">"                                     { return GT_OP; }
"<"                                     { return LT_OP; }


";"                                     { return ';'; }                                     
","                                     { return ','; }
"("                                     { return '('; }
")"                                     { return ')'; }
"{"                                     { return '{'; }
"}"                                     { return '}'; }
"["                                     { return '['; }
"]"                                     { return ']'; }


[ \t\r\n]+                                {  }


"//".*                                  {  }
"/*"([^*]|\n|\*+[^*/])*\*+"/"           {  }

.                                       { printf("ERROR: UNRECOGNIZED TOKEN '%s' AT LINE %d\n", yytext, yylineno); }

%%

/*
int main(int argc, char **argv)
{
    if(argc < 2)
    {
        fprintf(stderr, "Too few arguments, please type: %s file.txt\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(!yyin)
    {
        perror("Can't open file...");
        return 1;
    }

    yyparse(); // Call parser, it will call lexer internally. 

    fclose(yyin);
    return 0;
}
*/