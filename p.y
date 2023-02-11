
%{
	#include<stdio.h>
        int symbols[10000];
        int check[10000];
        int print_array[50];
        int i,f;
        int temp=0;
        int temp1=0;
        int value,flag,s_temp;
       
       
%}

%token  MAIN INT FLOAT CHAR NUM VAR PLUS MINUS MULT DIV MOD INC DEC ASSIGN GT LT EE GTE LTE NTE FBS FBC SBS SBC COMA SM PRINT IF ELSE FOR COLON SWITCH CASE DEFAULT
%nonassoc IF
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV	


%%

program: MAIN FBS FBC SBS cstatement SBC { 
 
                                
                                printf("\nsuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement {printf("cstatement : %d\n",$2);}
	
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
                                        if($3<26)
                                        {
							
						  if(check[$3] == 1)
						  {
						      printf("error: multiple declaration for '%c'\n",$3+'a');
						  }
						  else
						  {
						      check[$3] = 1;
						  }
                                        } 
                                        else
                                        {
                                                  if(check[$3] == 1)
				                  {
					              printf("error: multiple declaration!!! \n");
				                  }
					          else
					          {
						      check[$3] = 1;
					          }	
                                        }
		         }

     |VAR	         {             
                                        if($1<=26)
                                        {
                                                   
							if(check[$1] == 1)
							{	
								printf("error: multiple declaration for '%c' !!!\n",$1+'a');
							}
							else
							{
								check[$1] = 1;
							}
                                        }
                                        else
					{ 
		                                   if(check[$1] == 1)
					           {	
					               printf("error: multiple declaration!!!\n");
					           }
				                   else
				                   {
					               check[$1] = 1;
					           }
					}
			}
     ;


statement: expression SM 
        
        |  print_fun			

        | VAR ASSIGN expression SM 		{ 
							 $$=$3;  
                                                        symbols[$1]=$3;
                                                         $$ = symbols[$1];
                                                        
                                                         if($1<26) 
							 { 
                                                                if(check[$1] != 1)
                                                                {
							            printf("error: variable '%c' is undeclared\n",$1+'a');
								}
                                                        
                                                         }
                                                         else
                                                         {
                                                                 if(check[$1] != 1)
                                                                 {
							             printf("error: undeclared variable!!!\n");
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
													printf("Step : %d and value of expression : %d\n",i,$10);
		                                                                                                  }
                                                                                                       printf("ForLoop executes %d times\n",count);
		                                                                                      
                                                                                                }
                                                                                      if(flag==2){ 
		                                                                                  for(i=$3;i>value;i-=dec)
		                                                                                                 {
                                                                                                                   count++;
												printf("Step : %d and value of expression : %d\n",i,statement);
		                                                                                                  }
                                                                                                       printf("ForLoop executes %d times\n",count);
		                                                                                      
                                                                                                }
                                                                                      
                                                                                           else { 
                                                                                                      printf("ForLoop not execute\n");
                                                                                                }
                                                                                      flag=0;
                                                                         }

        | SWITCH FBS expression FBC SBS switchcase Default SBC {   printf("Switch statement successfully execute !!!\n"); }
	;



expression: NUM				{ $$ = $1;}

	| VAR				{       $$ = symbols[$1];
                                               s_temp=symbols[$1];
                                        }

	| expression PLUS expression	{ $$ = $1 + $3; }

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

        | expression DIV expression      {       if($3>0)
                                                {
                                                         $$=$1%$3;
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



forcase:VAR ASSIGN expression {     symbols[$1]=$3; 
                                             $$=$3; 
                                      
                                                          
                              }
                                      
	|expression { $$=$1; }
        ;




switchcase:  
	   | switchcase Case
	   ;

Case : CASE NUM COLON statement  {
						if(s_temp==$2) {
							          temp1=1;
							          printf("Case No : %d execute and Result  is : %d \n",$2,$4);
						               }
				     }
				 ;

Default : DEFAULT COLON statement  {
						if(temp1==0) {
							       printf("Default Result is :  %d \n",$3);
						             }
				}
	;    



print_fun: PRINT FBS variable FBC SM     {
                                                          temp--;
			                                  printf("printed Value is :");
                                                          for(i=0;i<=temp;i++)
                                                          {
						             printf("%d  ",print_array[i]);
							  }
                                                          printf("\n");
                                                          temp=0;i=0;														  
                                         }
         ;

variable: variable COMA VAR     {
                       
                                         if($3<26)
                                         {
                                                   
							if(check[$3] == 1)
							{	
								  print_array[temp++]=symbols[$3];
							}
							else
							{
						               printf("error: variable '%c' is undeclared\n",$3+'a');
				                        }
                                        }
                                        else
					{ 
		                                        if(check[$3] == 1)
					                {	
					                        print_array[temp++]=symbols[$3];
					                }
                                                         else
				                        {
					                        printf("error: undeclared variable!!!\n");
					                }
					}

			   }

   |VAR                    { if($1<26)
                                        {
                                                   
							if(check[$1] == 1)
							{	
								print_array[temp++]=symbols[$1];
							}
							else
							{
						                  printf("error: variable '%c' is undeclared\n",$1+'a');
				                        }
                                        }
                                        else
					{ 
		                                   if(check[$1] == 1)
					           {	
					               print_array[temp++]=symbols[$1];
					           }
				                   else
				                   {
					               printf("error: undeclared variable!!!\n");
					           }
					}

              }
   ;



%%
int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}