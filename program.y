%{
#include<stdio.h>
#include<stdlib.h>
int yylex();
void yyerror();

int exp_call=0;
int scol_cnt_infor=0;
int equal_to_in_for=0;
int operator_in_for=0;
int pdt_for=0;
int sd_for=0;
int id_call=0;
int equal_call=0;
int left_par=0;
int right_par=0;
int comma=0;
int semicolon=0;
int left_curly=0;
int closing_curly_braces=0;
int prim_data=0;
int id_k=0;
int op_k=0;
int else_cnt=0;
int for_cond=0;
int open_count=0;
%}

%token COMMENT
%token MULTIPLE_COMMENT
%token IF
%token ELSE
%token FOR
%token INTEGER
%token FLOAT
%token SEMICOLON
%token COLON
%token EQ
%token LEFT_PAR
%token RIGHT_PAR
%token COMMA
%token STRING
%token OPERATOR
%token PACKAGE
%token KEYWORD
%token ARRAY
%token PRIMITIVE_DATA_TYPE_NUMERIC
%token DERIVED_DATA_TYPE
%token INBUILT_FUNCTION
%token PROGRAMMER_DEFINED_FUNCTION
%token CODE_INITIATIVE
%token IDENTIFIER
%token SPECIAL_CHARACTER
%token LEFT_CURLY
%token RIGHT_CURLY
%token LITERAL_STRING
%token LITERAL_CONSTANT


%left '+'

%%

GO: Z{

        if (prim_data==1){
          if (equal_call>comma+1){
            printf("\n Error Appears! Many equal to sign occurs\n");
            return 0;
          }
          else{
            goto noerr;
          }
        }
        if (equal_call>1){
          printf("\n Error Appears! Many equal to sign occurs\n");
          return 0;
        }

        if (left_par!=right_par){
              printf("\n Error Appears! Unbalanced parenthises found.\n");
              return 0;
        }
        noerr:
        printf("\n \n INPUT CODE IS ACCEPTED \n");
        return 0;
      }

Z : SEMICOLON {exp_call=1;for_cond++;}
  | EQ  {equal_call++;exp_call=1;for_cond++;} Z
  | IDENTIFIER  {id_call++;exp_call=1;for_cond++;} Z
  | OPERATOR  {exp_call=1;for_cond++;} Z
  | COMMA  {comma++;exp_call=1;for_cond++;} Z
  | LEFT_PAR  {left_par++;exp_call=1;for_cond++;} Z
  | RIGHT_PAR  {right_par++;exp_call=1;for_cond++;} Z
  | RIGHT_CURLY Z
  | LEFT_CURLY Z
  | PRIMITIVE_DATA_TYPE_NUMERIC   {prim_data++;exp_call=1;for_cond++ ;if (prim_data==2){printf("\n Error! More number of primitive data type(>1) found.\n");return 0;}} Z
  | IF K
  | ELSE {
      else_cnt=1;
      if (exp_call==1){
          printf("\n Error Appears! unexpected syntax before else.\n");
          return 0;
      }

    }
  | FOR {if (for_cond!=0){
      printf("Error Appears! Unexpected syntax before for keyword occurs.\n");
      return 0;
    }
  } T
  | CODE_INITIATIVE Z
  | INBUILT_FUNCTION V
  | COMMENT Z
  | MULTIPLE_COMMENT Z
  |  
  ;



K : RIGHT_PAR {
    closing_curly_braces++;
    if (exp_call==1){
      printf("\n Error Appears! Unexpected syntax before if or while statement.\n");
      return 0;
    }
    if (closing_curly_braces!=left_curly){
      printf("\n Error Appears! Number of opening curly braces and closing curly braces are not equal.\n");
      return 0;
    }
    if (op_k>id_k){
      printf("\n Error Appears! MOre no.of operators found.\n");
      return 0;
    }
  }
  | LEFT_PAR {left_curly++;} K
  | INTEGER {id_k++;}K
  | OPERATOR {op_k++;}K
  | IF{
    printf("\n Error Appears! More than two conditions at the same time.\n");
    return 0;
  }
  | IDENTIFIER {id_k++;}K
  | Z
  ;

T : LEFT_CURLY{open_count++;
    if (open_count==2){
      printf("\n Error Appears! More no.of opening parenthises.\n");
      return 0;
    }
  } T
  | IDENTIFIER Z
  | INTEGER T
  | EQ{equal_to_in_for++;} T
  | PRIMITIVE_DATA_TYPE_NUMERIC {pdt_for++;}T
  | OPERATOR{operator_in_for++;} T
  | SEMICOLON {scol_cnt_infor++;}T
  | RIGHT_CURLY{
      if (scol_cnt_infor>=3){
        printf("\n Error Appears! found %d semicolon expected 2.\n",scol_cnt_infor);
        return 0;
      }
      if (operator_in_for==0){
        printf("\n Error! 0 operator.\n");
        return 0;
      }
      if (pdt_for>=2){
        printf("\n Error Appears! Found 2 or more primitive data type.\n");
        return 0;
      }
      if (equal_to_in_for==0){
        printf("\n Error Appears! 0 equal to operators found.\n");
        return 0;
      }
  }
 | IDENTIFIER T
 ;

V : SEMICOLON{
    if (exp_call==1){
      printf("\n Error Appears! Unexpected syntax before system defined function.\n");
      return 0;
    }
    if (sd_for>=1){
      printf("\n Error Appears! More than 1 system defined function at the same time.\n");
      return 0;
    }
  }
  | INBUILT_FUNCTION {
    sd_for++;
  } V
  | LEFT_PAR V
  | COMMA V
  | LEFT_CURLY Z
  | IDENTIFIER V
  | RIGHT_PAR V;




%%

void main(){
  printf ("\n Enter GO Code that you want to test: \n");
  yyparse();

}
void yyerror(){
  printf ("\n\n Code has some errors,please check it\n");
}
