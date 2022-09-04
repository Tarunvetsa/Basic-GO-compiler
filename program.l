%{

	#include<stdio.h>
	#include "program.tab.h"
	extern int yylval;

%}

%%

" "|\t|\n {}

"//".*" "* {return COMMENT;}

^"/*"[^*]*"*/"|"*/"[*]*"*/" {return MULTIPLE_COMMENT;}

["](\\.|[^"\\])*["] {return STRING;}

"package"|"main"|"import"|\"fmt\" {return CODE_INITIATIVE;}

\"time\"|\"list\"]|\"http\"|\"strconv\"|\"syscall\" {return PACKAGE;}

"default"|"interface"|"select"|"case"|"defer"|"go"|"map"|"chan"|"goto"|"const"|"fallthrough"|"range"|"type"|"var"|"break"|"continue" {return KEYWORD;}


for     return FOR;

if  	return IF;

else    return ELSE;

; return SEMICOLON;

: return COLON;

, return COMMA;

"="     {return EQ;}

"{" {return LEFT_CURLY;}

"}" {return RIGHT_CURLY;}

"(" {return LEFT_PAR;}

")" {return RIGHT_PAR;} 
fmt.Println|fmt.Printf return INBUILT_FUNCTION;
 

func\s([a-zA-Z]|[_])+([a-zA-Z0-9]*+[_]*+[a-zA-Z]*)*+"(" {return INBUILT_FUNCTION;}

[a-zA-Z_][a-zA-Z0-9_]+"(" {return INBUILT_FUNCTION;}

([a-zA-Z]|[_])+([a-zA-Z0-9]*+[_]*+[a-zA-Z]*)*"["[0-9]*"]"("string"|"int")  {return ARRAY;}


"+"|"-"|"*"|"/"|"%"|"&&"|"||"|"!"|"&"|"|"|"^"|"<<"|">>"|"++"|"--"|"+="|"-="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|="|":="|"=="|"<="|">="|"!="|">"|"<"  {return OPERATOR;}

"unit"|"rune"|"unitptr"|"byte"|"int8"|"int16"|"int32"|"int64"|"unit8"|"unit16"|"unit32"|"unit64"|"float32"|"float64"|"complex64"|"complex128" {return PRIMITIVE_DATA_TYPE_NUMERIC;}

"struct" {return DERIVED_DATA_TYPE;}

[-,+]?[0-9]+ {return INTEGER;}

[-,+]?[0-9]+[.][0-9]+ {return FLOAT;} 

\".*\" {return LITERAL_STRING;}

\'.*\' {return LITERAL_CONSTANT;}

([a-zA-Z]|[_])+([a-zA-Z0-9]*+[_]*+[a-zA-Z]*)* {return IDENTIFIER;} 

"#"|"@"|"!"|"$" {return SPECIAL_CHARACTER;}




%%

int yywrap(){
  return 1;
}



