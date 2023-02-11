%{
#include<string.h>
int counting_header=0;
int counting_integer=0;
int counting_double=0;
int counting_comment=0;
int i=0;
int counting_arithmetic=0;
int counting_functions=0;
int counting_condition=0;
int counting_variable=0;
int counting_array=0;
int counting_loop=0;
int counting_keyword=0;
int counting_switch=0;
%}
operator "Plus"|"Minus"|"Mult"|"Div"|"Mod"|"<-"|"&"|"|"           
relational_operator "Gt"|"Lt"|"Lte"|"Gte"|"Ee"|"&&"|"||"|"Nte"
variable [A-Z|a-z|_]+[a-z|A-Z|0-9|_]*
integer [+-]?[0-9]+
double [+-]?[0-9]+[.][0-9]+|[+-]?[.][0-9]+
digit [0-9]
keyword "look"|"found"|"start"|"end"
unaryOperator "Inc"|"Dec"
%%
"rakibHeader"[ ]*[<].+[>] {
printf("Header found : ");
for(i=11;i<strlen(yytext);i++)
{
printf("%c",yytext[i]);
}
printf("\n");
counting_header++;
}

{variable}{operator}{integer} {
printf("Integer Value assign\n");
counting_integer++;
}

{variable}[" "]{unaryOperator} {
    printf("Post increment or decrement %s\n",yytext);
}
{unaryOperator}[" "]{variable} {
    printf("Pre increment or decrement %s\n",yytext);
}


{variable}{operator}{double} {
printf("double value assign\n");
counting_double++;
}



"#".* {
    printf("Single comment found : ");
    for(i=1;i<strlen(yytext);i++)
    {
        printf("%c",yytext[i]);
    }
    printf("\n");
    counting_comment++;
}
[*][^*]+[*]	{
printf("Multiline comment found : ");
    for(i=1;i<strlen(yytext)-1;i++)
    {
        printf("%c",yytext[i]);
    }
    printf("\n");
    counting_comment++;}

{variable}{operator}({variable}|{integer}|{double}){operator}({integer}|{double}) {
    counting_arithmetic++;
    printf("Arithmetic Operation\n");
}

"Fbs" {
printf("This is first bracket started\n");
}

"Fbc" {  
printf("This is first bracket closed\n") ; 
}

"Sbs" {
printf("This is second bracket started\n");
}

"Sbc" {   
printf("This is second bracket closed\n");
}

",," {
printf("This is comma\n");
}

"$$" { 
printf("This is semicolon\n");
}

"RakibFunction ".* {
printf("function called\n");
int i;
counting_functions++;
for(i=14;i<strlen(yytext);i++){
printf("%c",yytext[i]);
}
printf("\n");
}

"If "{variable}[" "]*{relational_operator}[" "]*({variable}|{integer}|{double}) {
    printf("If condition : %s\n",yytext);
    counting_condition++;
}
"ElseIf "{variable}[" "]*{relational_operator}[" "]*({variable}|{integer}|{double}) {
    printf("ElseIf condition : %s\n",yytext);
    counting_condition++;
}
"Else" {
    printf("Else condition\n");
    counting_condition++;
}
"conditionEnd " {
    counting_condition--;
    printf("condition ended\n");
}
"DeclaringVariable "({variable},)*{variable} {
    printf("variable Declared\n");
    for(i=18;i<strlen(yytext);i++)
    {
        if(yytext[i] == ",")
        {
            printf("\n");
        }
        printf("%c",yytext[i]);
    }
    printf("\n");
    counting_variable++;
}
"array "[<]{variable}[>]{digit}* {
	
	printf("Declaring Array : ");
    for(i=5;i<strlen(yytext);i++)
    {
        printf("%c",yytext[i]);
    }
    printf("\n");
	counting_array++;

}

"For"[" "]*{variable}[" "]*{relational_operator}[" "]*({integer}|{double}|{variable}) {
    printf("For loop started : %s\n",yytext);
    counting_loop++;
}
"ForEnd" {
    printf("For loop ended\n");
    counting_loop--;
}


{keyword} {
    printf("Keyword is found : %s\n",yytext);
    counting_keyword++;
}

"Switch "[<]{variable}[>] {
    printf("Switch case is found %s\n",yytext);
    counting_switch++;
}
"case "{digit}*[>] {
    printf("Case condition : %s\n",yytext);
}
"Default" {
    printf("Default condition\n");
}
[ \t\n]*	;

. {
printf("Unknown Character.\n");
}
%%
int yywrap()
{
return 1;
}

int main()
{
yyin=freopen("input.txt","r",stdin);
yyout=freopen("output.txt","w",stdout);
yylex();
printf("\n\n------Rakib Mahmud 1807077--------\n\n");
printf("Showing the existing things\n");
printf("Number of header file : %d\n",counting_header);
printf("Number of expression for integer : %d\n",counting_integer);
printf("Number of expression for double : %d\n",counting_double);
printf("Nummber of comment : %d\n",counting_comment);
printf("Number of Arithmetic operator : %d\n",counting_arithmetic);
printf("Number of functions are : %d\n",counting_functions);
printf("Number of conditions are : %d\n",counting_condition);
printf("Number of variables are : %d\n",counting_variable);
printf("Number of arrays are : %d\n",counting_array);
printf("Number of loops are : %d\n",counting_loop);
printf("Number of keywords are : %d\n",counting_keyword);
printf("Number of switch cases are : %d\n",counting_switch);
return 0;
}