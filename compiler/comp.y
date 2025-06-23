%{
#include <stdio.h>
typedef enum {
    AST_NUM,
    AST_STR;
    AST_CHAR;
    AST_FLOAT;
    AST_FUNC_DEF;
    AST_PARA_LIST;
    AST_PARA;
    AST_DECL;
    AST_DECL_INI;
    AST_ASSIGN;
    AST_DEFINE;
    AST_ADD;
    AST_SUB;
    AST_MUL;
    AST_DIV;
    AST_MOD;
    AST_INC;
    AST_DEC;
    AST_AND;
    AST_OR;

} ASTNodeType;
void yyerror(char* s);

struct ASTNode{
    char* tokenType;
    ASTNodeType type;
    char *value;
    struct ASTNodeList *children;
}

%}

%union {
    struct ASTNode *node;
    int ival;
    char *sval;
    struct ASTNodeList *list;
}

/* Tokens */

%token DEFINE

%token NUM STR CHR VFLOAT

%token WHILE FOR DO

%token IF ELSE SWITCH CASE DEFAULT

%token BREAK CONTINUE GOTO

%token INT CHAR FLOAT

%token MAIN SCANF PRINTF RETURN ABS

%token ID

%token EQL NEQL GRTEQ LSTEQ GRT LST

%token INC DEC

%token ADDAS SUBAS MULAS DIVAS MODAS ANDAS ORAS BANDAS BORAS LSHAS RSHAS XORAS AS 

%token ADD SUB MUL DIV MOD

%token LP RP LBE RBE LBT RBT

%token SC CM COL

%token AND OR NOT

%token BNOT LSH RSH XOR BOR BAND

%define parse.error verbose

%type <node> preprocess_list declaration_list preprocess_statement

%type 

%%

program
    : preprocess_list declaration_list {}
    ;

preprocess_list
    :
    | preprocess_list preprocess_statement {}
    | preprocess_statement {}
    ;

preprocess_statement
    : define_id define_value {}
    | define_id 
    | define_id LP ID RP LBE RBE SC {}
    | define_id LP ID RP LBT RBT SC {}
    ;

define_value
    : value {}
    | L ID RP {}

%%

struct ASTNode* create_leaf(ASTNodeType type, char *value) {
    struct ASTNode* node = (struct ASTNode*)malloc(sizeof(struct ASTNode));
    node->type = type;
    node->value = value;
    node->children = NULL;
    return node;
}

yyerror(char *s)
{
 fprintf(stdout, "\nError: %s\n", s);
}

int main(){
    yyin=fopen("main.c","r");
    yyout=fopen("tokens.txt","w");
    yyparse();
    fclose(yyout);
    return 0;
}