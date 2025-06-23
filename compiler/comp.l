%{
#include "y.tab.h"
#include <stdio.h>
%}

%%

    /*Preprocessor*/
"#define" return DEFINE;

    /*Whitespaces*/
[ \t\n]+ ;

    /*Comments*/
"//".*|"/*"(.*[\n].*)*"*/" ;

    /*Values*/
[0-9]+\.[0-9]*(e[+-]?[0-9]+)? return ;
[0-9]*\.[0-9]+(e[+-]?[0-9]+)? ;
0[bB][10]+ ;
0[xX][0-9a-fA-F] ;
0[0-9]+ ;
[1-9][0-9]*(e[+-]?[0-9]+)? ;
0 ;
\"[^\"]*\" ;
\'\\?.\' ;


    /*Loop*/
"while" ;
"for" ;
"do" ;

    /*Condition*/
"if" ;
"else" ;
"switch" ;
"case" ;
"default" ;

    /*Control*/

"break" ;
"continue" ;

    /*Types*/
"int" ;
"float" ;
"char" ;
"double" ;
"long" ;
"signed" ;
"unsigned" ;
"void" ;

    /*SOME REQUIRED*/
"main" ;
"return" ;

    /*Identifiers*/
[a-zA-Z_][a-zA-Z0-9_]* ;

    /*Operators*/
"==" ;
"!=" ;
">=" ;
"<=" ;
">" ;
"<" ;

"++" ;
"--" ;

    /*Assignment*/
"+=" ;
"-=" ;
"*=" ;
"/=" ;
"%=" ;
"&&=" ;
"||=" ;
"&=" ;
"|=" ;
"<<=" ;
">>=" ;
"^=" ;
"=" ;

"+" ;
"-" ;
"*" ;
"/" ;
"%" ;

    /*Brackets*/
"(" ;
")" ;
"{" ;
"}" ;
"[" ;
"]" ;

    /*Semicolon*/
";" ;
"," ;
":" ;

    /*Condition*/
"&&" ;
"||" ;
"!" ;

    /*Bitwise*/
"~" ;
"<<" ;
">>" ;
"^" ;
"|" return 0;
"&" ;

%%

int yywrap() {return 1;}

int main(int argc,char** argv){
    yyin=fopen(argv[0],"r");
    if(!yyin){
        perror("File not working.\n");
    }
    yylex();
    fclose(yyin);
    return 0;
}