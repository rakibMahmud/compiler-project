
%{
	#include<stdio.h>
        double symbols[10000];
        int check[10000];
        float print_array[50];
        int i,f,k;
        int temp=0;
        int temp1=0;
        int value,flag,s_temp;

FILE *yyin,*yyout;
int yylex(void);
void yyerror(char *s);

       
       
%}

%union
{
  struct compiler {
    int varvalue,length;
	char str[20];
  }s;
  double Dob; 
}

%token  MAIN INT FLOAT CHAR  PLUS MINUS MULT DIV MOD INC DEC ASSIGN GT LT EE GTE LTE NTE FBS FBC SBS SBC COMA SM PRINT IF ELSE FOR COLON SWITCH CASE DEFAULT
%token <Dob> NUM
%type <Dob> statement
%type <Dob> expression
%type <Dob> forcase
%type <Dob> Case
%type <Dob> Default
%type <Dob> variable
%type <s> ID1
%token <s>  VAR
%left PLUS MINUS
%left MULT DIV	


%%

program: MAIN FBS FBC SBS cstatement SBC { 
 
                                
                                printf("\nsuccessful compilation\n"); }
	 ;

cstatement: 

	| cstatement statement
	
	| cstatement cdeclaration
        
        | cstatement print_fun
	;
	
cdeclaration:	TYPE ID1 SM	{ printf("\nvalid declaration\n"); }
			;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 COMA VAR	 {       
                                        if($3.varvalue<26)
                                        {
							
						  if(check[$3.varvalue] == 1)
						  {
						      printf("error: multiple declaration for %c\n",$3.varvalue+'a');
						  }
						  else
						  {
						      check[$3.varvalue] = 1;
						  }
                                        } 
                                        else
                                        {
                                                  if(check[$3.varvalue] == 1)
				                  {
					              printf("error: multiple declaration for  ");
                                                          for(k=0;k<$3.length;k++)
							  {
							    printf("%c",$3.str[k]);
							  }
							  printf("\n");
				                  }
					          else
					          {
						      check[$3.varvalue] = 1;
					          }	
                                        }
		         }

     |VAR	         {             
                                        if($1.varvalue<26)
                                        {
                                                   
							if(check[$1.varvalue] == 1)
							{	
								printf("error: multiple declaration for %c !!!\n",$1.varvalue+'a');
							}
							else
							{
								check[$1.varvalue] = 1;
							}
                                        }
                                        else
					{ 
		                                   if(check[$1.varvalue] == 1)
					           {	
					               printf("error: multiple declaration for  ");
                                                          for(k=0;k<$1.length;k++)
							  {
							    printf("%c",$1.str[k]);
							  }
							  printf("\n");
					           }
				                   else
				                   {
					               check[$1.varvalue] = 1;
					           }
					}
			}
     ;


statement: expression SM    
        
        |  print_fun			

        | VAR ASSIGN expression SM 		{ 
							   
                                                        symbols[$1.varvalue]=$3;
                                                         $$ = $3;
                                                       // printf("assign symbol table %lf\n",symbols[$1.varvalue]);
														//printf("assign %lf\n",$3);
                                                         if($1.varvalue<26) 
							 { 
                                                                if(check[$1.varvalue] != 1)
                                                                {
							            printf("error:undeclared variable is %c \n",$1.varvalue+'a');
								}
                                                        
                                                         }
                                                         else
                                                         {
                                                                 if(check[$1.varvalue] != 1)
                                                                 {
							             printf("error: undeclared variable is ");
                                                                
                                                        for(k=0;k<$1.length;k++)
							  {
							    printf("%c",$1.str[k]);
							  }
							  printf("\n");
							         } 
                                                          }
                                                      
						}
        |IF FBS expression FBC  SBS  statement SBC    {      if($3)
                                                             { 
                                                                    printf(" if statement successfully execute !!!\n");
                                                                    
                                                             }

                                                     }

        |IF FBS expression FBC  SBS  statement SBC ELSE SBS statement SBC {      
                                                                                         if($3)
                                                                                       {
												 printf("if statement successfully execute !!!\n");
                                                                                                
										       }
										       
                                                                                       else
                                                                                       {
												 printf("else statement successfully execute !!!\n");
										       }
                                                                            }
        |FOR FBS forcase SM forcase SM forcase  FBC SBS statement SBC    {  
                                                                                     int inc=$7-$3;
                                                                                     int count=0;
                                                                                     int dec=$3-$7;
                                                                                     if(flag==1){ 
		                                                                                  for(i=$3;i<value;i+=inc)
		                                                                                                 {
                                                                                                                   count++;
		                                                                                                  }
                                                                                                       printf("ForLoop executes %d times\n",count);
		                                                                                      
                                                                                                }
                                                                                      if(flag==2){ 
		                                                                                  for(i=$3;i>value;i-=dec)
		                                                                                                 {
                                                                                                                   count++;
		                                                                                                  }
                                                                                                       printf("ForLoop executes %d times\n",count);
		                                                                                      
                                                                                                }
                                                                                      
                                                                                           else { 
                                                                                                      printf("ForLoop not execute\n");
                                                                                                }
                                                                                      flag=0;
                                                                         }

        | SWITCH FBS expression FBC SBS switchcase Default SBC {   printf("Switch statement successfully execute !!!\n"); 
                                                                       temp1=0;}
	;



expression: NUM				{ $$ = $1;
								//printf("NUM: %lf\n", $1);
								}

	| VAR				{       
                                  $$ = symbols[$1.varvalue];
                                  s_temp=symbols[$1.varvalue];
                                        }

	| expression PLUS expression	{ $$ = $1 + $3;
									//printf("%d plus expression\n",$$);
									 }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\nerror: division by zero\t");
				  		} 	
				    	}

        | expression MOD expression      {       if($3>0)
                                                {
                                                         $$=(int)$1%(int)$3;
		                                 }
					        else
						{        $$=0;
							 printf("error: modulus by zero \n");
										
						}
						}

                                           
        | expression INC          {$$ = $1++; }

        | expression DEC          {$$ = $1--; }

	| expression LT expression	{         if($1 < $3){
                                                           
                                                            $$=1; 
                                                            value=$3;
                                                            flag=1;

                                                           }
                                                     else  {
                                                              $$=0;
                                                           }
                                                  
                                       }

	| expression GT expression	{     
                                                  if($1 > $3){
                                                            $$ =1; 
                                                            value=$3;
                                                            flag=2;

                                                           }
                                                     else  {
                                                              $$=0;
                                                           }
                                                  
                                        }

        | expression EE expression      {         if($1==$3)
                                                  {
                                                        $$=1;
                                                  }
                                                  else
						  {
 							$$=0;
						  }
					}

        | expression NTE expression     {         if($1!=$3)
                                                  {
                                                        $$=1;
                                                  }
                                                  else
						  {
 							$$=0;
						  }
                                        }

        | expression GTE expression	{ $$ = $1 >= $3;}

        | expression LTE expression	{ $$ = $1 <= $3; }

	| FBS expression FBC		{ $$ = $2;	}
	;



forcase:VAR ASSIGN expression {     symbols[$1.varvalue]=$3; 
                                             $$=$3; 
                                      
                                                          
                              }
                                      
	|expression { $$=$1; }
        ;




switchcase:  
	   | switchcase Case
	   ;

Case : CASE NUM COLON statement  {
						if(s_temp==(int)$2) {
							          temp1=1;
							          printf("Case No : %.0f execute and Result  is : %f \n",$2,$4);
						               }
				     }
				 ;

Default : DEFAULT COLON statement  {
						if(temp1==0) {
							       printf("Default Result is :  %f \n",$3);
						             }
				}
	;    



print_fun: PRINT FBS variable FBC SM     {
                                                          temp--;
			                                  printf("printed Value is :");
                                                          for(i=0;i<=temp;i++)
                                                          {
						             printf("%f  ",print_array[i]);
							  }
                                                          printf("\n");
                                                          temp=0;i=0;														  
                                         }
         ;

variable: variable COMA VAR     {
                       
                                         if($3.varvalue<26)
                                         {
                                                   
							if(check[$3.varvalue] == 1)
							{	
								  print_array[temp++]=symbols[$3.varvalue];
							}
							else
							{
						               printf("error:undeclared variable  is %c\n",$3.varvalue+'a');
				                        }
                                        }
                                        else
					{ 
		                                        if(check[$3.varvalue] == 1)
					                {	
					                        print_array[temp++]=symbols[$3.varvalue];
					                }
                                                         else
				                        {
					               	             printf("error: undeclared variable is ");
                                                                     for(k=0;k<$3.length;k++)
							                                     {
							                                      printf("%c",$3.str[k]);
							                                     }
							                                     printf("\n");
					                }
					}

			   }

   |VAR                    { if($1.varvalue<26)
                                        {
                                                   
							if(check[$1.varvalue] == 1)
							{	
								print_array[temp++]=symbols[$1.varvalue];
							}
							else
							{
						                  printf("error:undeclared variable  is %c\n",$1.varvalue+'a');
				                        }
                                        }
                                        else
					{ 
		                                   if(check[$1.varvalue] == 1)
					           {	
					               print_array[temp++]=symbols[$1.varvalue];
					           }
				                   else
				                   {
					               printf("error: undeclared variable is \n");
                                                       	   for(k=0;k<$1.length;k++)
							  {
							    printf("%c",$1.str[k]);
							  }
							  printf("\n");
					           }
					}

              }
   ;



%%
yyerror(char *s){
	printf( "%s\n", s);
}

int main()
{
	yyin = freopen("int.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();

}