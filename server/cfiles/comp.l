%{
//#include "y.tab.h"
#include <string.h>
int position = 0;
int start = 0;

void printToken(const char* token, const char* value) {
    int len = yyleng;
    int end = position + len;
    if(strcmp(token, "STR") == 0) {
        char *temp=malloc(len + 3);
        for(int i=0; i<len-1; i++){
            temp[i+1] = value[i];
        }
        temp[len+2] = '\0';
        temp[len+1] = '"';
        temp[len]='\\';
        temp[0]='\\';
        fprintf(yyout, "  { \"token\": \"%s\", \"value\": \"%s\", \"start\": %d, \"end\": %d },\n", token, temp, position, end);
    }
    else
        fprintf(yyout, "  { \"token\": \"%s\", \"value\": \"%s\", \"start\": %d, \"end\": %d },\n", token, value, position, end);
    position = end;
}

%}

%%

    /*Preprocessor*/
"#define" printToken("DEFINE", yytext);

    /*Whitespaces*/
[ \t]+ position += yyleng;
[\n]+ printToken("NEWLINE", "\\n");

    /*Comments*/
"//".*|"/*"(.*[\n].*)*"*/" position += yyleng;

    /*Values*/
[0-9]+ printToken("NUM", yytext);
\"[^\"]*\" printToken("STR", yytext);
\'[^\']*\' printToken("CHR", yytext);
[0-9]+\.[0-9]+ printToken("VFLOAT", yytext);


    /*Loop*/
"while" printToken("WHILE", yytext);
"for" printToken("FOR", yytext);
"do" printToken("DO", yytext);

    /*Condition*/
"if" printToken("IF", yytext);
"else" printToken("ELSE", yytext);
"switch" printToken("SWITCH", yytext);
"case" printToken("CASE", yytext);
"default" printToken("DEFAULT", yytext);

    /*Control*/

"break" printToken("BREAK", yytext);
"continue" printToken("CONTINUE", yytext);
"goto" printToken("GOTO", yytext);

    /*Types*/
"int" printToken("INT", yytext);
"float" printToken("FLOAT", yytext);
"char" printToken("CHAR", yytext);

    /*SOME REQUIRED*/
"main" printToken("MAIN", yytext);
"return" printToken("RETURN", yytext);
"printf" printToken("PRINTF", yytext);
"scanf" printToken("SCANF", yytext);
"abs" printToken("ABS", yytext);

    /*Identifiers*/
[a-zA-Z_][a-zA-Z0-9_]* printToken("ID", yytext);

    /*Operators*/
"==" printToken("EQL", yytext);
"!=" printToken("NEQL", yytext);
">=" printToken("GRTEQ", yytext);
"<=" printToken("LSTEQ", yytext);
">" printToken("GRT", yytext);
"<" printToken("LST", yytext);

"++" printToken("INC", yytext);
"--" printToken("DEC", yytext);

    /*Assignment*/
"+=" printToken("ADDAS", yytext);
"-=" printToken("SUBAS", yytext);
"*=" printToken("MULAS", yytext);
"/=" printToken("DIVAS", yytext);
"%=" printToken("MODAS", yytext);
"&&=" printToken("ANDAS", yytext);
"||=" printToken("ORAS", yytext);
"&=" printToken("BANDAS", yytext);
"|=" printToken("BORAS", yytext);
"<<=" printToken("LSHAS", yytext);
">>=" printToken("RSHAS", yytext);
"^=" printToken("XORAS", yytext);
"=" printToken("AS", yytext);

"+" printToken("ADD", yytext);
"-" printToken("SUB", yytext);
"*" printToken("MUL", yytext);
"/" printToken("DIV", yytext);
"%" printToken("MOD", yytext);

    /*Brackets*/
"(" printToken("LP", yytext);
")" printToken("RP", yytext);
"{" printToken("LBE", yytext);
"}" printToken("RBE", yytext);
"[" printToken("LBT", yytext);
"]" printToken("RBT", yytext);

    /*Semicolon*/
";" printToken("SC", yytext);
"," printToken("CM", yytext);
":" printToken("COL", yytext);

    /*Condition*/
"&&" printToken("AND", yytext);
"||" printToken("OR", yytext);
"!" printToken("NOT", yytext);

    /*Bitwise*/
"~" printToken("BNOT", yytext);
"<<" printToken("LSH", yytext);
">>" printToken("RSH", yytext);
"^" printToken("XOR", yytext);
"|" printToken("BOR", yytext);
"&" printToken("BAND", yytext);

%%

int yywrap() {return 1;}

int main(){
    yyin=fopen("temp.c","r");
    yyout=fopen("tokens.json","w");
    fprintf(yyout, "[\n");
    yylex();
    fseek(yyout, -2, SEEK_CUR);
    fprintf(yyout, "\n]\n");
    fclose(yyout);
    return 0;
}