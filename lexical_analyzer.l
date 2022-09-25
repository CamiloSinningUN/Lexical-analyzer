%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

typedef struct node
{
    char *word;
    struct node *next;
}  node;


node *idlist = NULL;
node *errorlist = NULL;


int idcounter = 0;
int errorcounter = 0;


%}

%option noyywrap

digit [0-9]
letter [a-zA-Z]
space " "
entero [\+\-]?{digit}+
p_decimal \.{digit}+
p_exp [Ee]{entero}
real {entero}(({p_decimal}?{p_exp})|({p_decimal}{p_exp}?))
cadena ["]([^"\\\n]|\\.|\\\n)*["]
caracter [']([^'\\\n]|\\.|\\\n)*[']
id ({letter}|_)(({letter}|{digit}|-|_)*({letter}|{digit}|_))?
comentario "//".*" "*
multicomentario \/\*(.*\n)*.*\*\/
gen [^\ \n\t\!\%\^(&&)\*\(\)\+\,\-\=\{\}\;\<\>]

%%

"int"|"float"|"long"|"char"|"main"|"void"|"scanf"|"printf"|"if"|"else"|"for"|"while"|"do"|"switch"|"case"|"default"|"break"|"return"|"auto"|"const"|"continue"|"double"|"enum"|"extern"|"goto"|"register"|"short"|"signed"|"sizeof"|"static"|"struct"|"typedef"|"union"|"unsigned"|"volatile" {
                        char yytextup[strlen(yytext)];
                        int j=0; 
                        char str[strlen(yytext)];
                        strcpy (str, yytext);
                        strcpy (yytextup, yytext);
                        char ch; 
                        while(str[j]){
                            ch=str[j];
                            yytextup[j] = toupper(ch); 
                            j++;
                        }
                        fprintf(yyout,"%s ",yytextup);
                    }

"{" {fprintf(yyout,"inicio= %s",yytext);}
"(" {fprintf(yyout,"parent-a= %s ",yytext);}
")" {fprintf(yyout,"parent-c= %s ",yytext);}
"}" {fprintf(yyout,"fin= %s ",yytext);}

"=" {fprintf(yyout,"op-asign= %s ",yytext);}

"*" {fprintf(yyout,"op-mult= %s ",yytext);}
"+" {fprintf(yyout,"op-sum= %s ",yytext);}
"-" {fprintf(yyout,"op-sust= %s ",yytext);}
"/" {fprintf(yyout,"op-div= %s ",yytext);}
"%" {fprintf(yyout,"op-mod= %s ",yytext);}

"==" {fprintf(yyout,"igual= %s ",yytext);}
"!=" {fprintf(yyout,"diferente= %s ",yytext);}
"<=" {fprintf(yyout,"menor-igual= %s ",yytext);}
">=" {fprintf(yyout,"mayor-igual= %s ",yytext);}
">" {fprintf(yyout,"mayor= %s ",yytext);}
"<" {fprintf(yyout,"menor= %s ",yytext);}

"&&" {fprintf(yyout,"and= %s ",yytext);}
"||" {fprintf(yyout,"or= %s ",yytext);}
"!" {fprintf(yyout,"no= %s ",yytext);}

    
";" {fprintf(yyout,"punto-coma= %s ",yytext);}
"," {fprintf(yyout,"coma= %s ",yytext);}
"." {fprintf(yyout,"punto= %s ",yytext);}

{entero} {fprintf(yyout,"Cte entera= %s ",yytext);}
{real} { fprintf(yyout,"Cte real= %s ",yytext);}
{cadena} { fprintf(yyout,"Cte cadena=%s ",yytext);}
{caracter} { fprintf(yyout,"Cte caracter=%s ",yytext);}

{comentario}    {fprintf(yyout,"Comentario (1 linea)= %s ",yytext);}
{multicomentario}    {fprintf(yyout,"Comentario (multilinea)= %s ",yytext);}



{entero}{id}  {
    node *n = malloc(sizeof(node));
    if (n == NULL)
    {
        return 1;
    }
    n->word = malloc(strlen(yytext) + 1);
    if (n->word == NULL)
    {
        return 1;
    }
    strcpy(n->word, yytext);
    n->next = errorlist;
    errorlist = n;
    errorcounter++;
    fprintf(yyout,"Error= %s ",yytext);
    }


{id}  { 
                        node *cursor = idlist;
                        bool found = false;
                        while (cursor != NULL)
                        {
                            if (strcmp(cursor->word, yytext) == 0)
                            {
                                found = true;
                                break;
                            }
                            cursor = cursor->next;
                        }

                        if (!found)
                        {
                            node *n = malloc(sizeof(node));
                            if (n == NULL)
                            {
                                return 1;
                            }
                            n->word = malloc(strlen(yytext) + 1);
                            if (n->word == NULL)
                            {
                                return 1;
                            }
                            strcpy(n->word, yytext);
                            n->next = idlist;
                            idlist = n;
                            idcounter++;
                        }
                        fprintf(yyout,"Id= %s ",yytext);
                    }  

(" "|\t|\n)* {ECHO;}  

[|&] {
    node *n = malloc(sizeof(node));
    if (n == NULL)
    {
        return 1;
    }
    n->word = malloc(strlen(yytext) + 1);
    if (n->word == NULL)
    {
        return 1;
    }
    strcpy(n->word, yytext);
    n->next = errorlist;
    errorlist = n;
    errorcounter++;
    fprintf(yyout,"Error= %s ",yytext);
    }

({gen})+ {
    node *n = malloc(sizeof(node));
    if (n == NULL)
    {
        return 1;
    }
    n->word = malloc(strlen(yytext) + 1);
    if (n->word == NULL)
    {
        return 1;
    }
    strcpy(n->word, yytext);
    n->next = errorlist;
    errorlist = n;
    errorcounter++;
    fprintf(yyout,"Error= %s ",yytext);
    }

%%

int main(int argc, char **argv)
{
    if(argc != 2){
        printf("La cantidad de argumentos introducida es errónea, intente de nuevo...\n");
        return 0;
    }else{
        extern FILE *yyin, *yyout; 
    
        //archivo con cualquier extension basado en c
        yyin = fopen(argv[1], "r"); 
    
        //crear o abrir el archivo
        yyout = fopen("Salida.txt", "w"); 
    
        yylex();

        //generar ids en forma de tabla
        fprintf(yyout,"\n\nTABLA DE IDENTIFICADORES\n");
        fprintf(yyout,"Hay %d identificadores\n",idcounter);

        node *cursor = idlist;
        while (cursor != NULL)
        {
            fprintf(yyout,"Id= %s; ", cursor->word);
            cursor = cursor->next;
        }

        //generar listado de errores lexicos
        fprintf(yyout,"\n\nLISTA DE ERRORES\n");
        fprintf(yyout,"Hay %d errores\n",errorcounter);
        
        cursor = errorlist;
        while (cursor != NULL)
        {
            fprintf(yyout,"Error= %s; ", cursor->word);
            cursor = cursor->next;
        }

        fclose(yyout);
        return 0; 
    }
}
