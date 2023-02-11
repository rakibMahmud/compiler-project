
%{
	#include<stdio.h>
	#include "p.tab.h"
	extern YYSTYPE yylval;
%}



%%
"*"[^*]+"*" 	{printf("MultiComment successfully executed\n");}
"@".*           {{printf("single Comment successfully executed\n");}}
"int"	{ return INT; }
"float"	{ return FLOAT; }
"char"	{ return CHAR; }

[-+]?[0-9]+	{ 
                //printf("yytext: %s\n", yytext);
		yylval.Dob = atof(yytext);
                //printf("FLEX: %lf\n", yylval.Dob);
		return NUM;
	        }

[-+]?[0-9]*[.][0-9]+   {
	                yylval.Dob=atof(yytext);
	                return NUM;
                       }

[a-z]+  {
       
        int  i,temp;
             temp=0; 
          if(yyleng>1) 
                 {
                    for(i=0;i<yyleng;i++)  {               
                                                temp += yytext[i] - 'a'+i;
                                                yylval.s.str[i]=yytext[i];
                                            }
                       
	                                   yylval.s.varvalue=temp+26;
	                                   yylval.s.length=yyleng;
                                      return VAR;
 
                 }

          else   {
                  yylval.s.varvalue= *yytext - 'a';
                
                  return VAR;
                 }
        }

"Plus"     {   return PLUS;  }

"Minus"    {   return MINUS; }

"Mult"     {   return MULT;  }

"Div"      {   return DIV;   }

"Mod"      {   return MOD;   }

"Inc"      {   return INC;   }

"Dec"      {   return DEC;   }

"<-"	   { return ASSIGN;  }

"Gt"       {   return GT;    }

"Lt"       {   return LT;    }

"Ee"       {   return EE;    }

"Gte"      {   return GTE;   }

"Lte"      {   return LTE;   }

"Nte"      {   return NTE;   }

"Fbs"      {   return FBS;   }

"Fbc"      {   return FBC;   }

"Sbs"      {   return SBS;   }

"Sbc"      {   return SBC;   }

"##"       {   return COMA;  }

"$$"       {   return SM;    }

":"        { return COLON;   }

"If"       {   return IF;    }

"Else"     {   return ELSE;    }

"For"      {   return FOR;   }

"Switch"   {   return SWITCH;  }

"Case"     {   return CASE;  }

"Default"  {   return DEFAULT; }

"Print"    {   return PRINT; }



"Int main_function" {   return MAIN;  }

[ \t\n]*	;

.	{
		yyerror("Unknown Character.\n");
	}


%%

int yywrap() {
        return 1;
}




















