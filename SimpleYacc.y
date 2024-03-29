%{
// ��� ���������� ����������� � ����� GPPGParser, �������������� ����� ������, ������������ �������� gppg
//"{"  LEFT_M_BRACKET
//"}"  RIGHT_M_BRACKET
//"["  LEFT_F_BRACKET
//"]"  RIGHT_F_BRACKET
    public Parser(AbstractScanner<int, LexLocation> scanner) : base(scanner) { }
%}

%output = SimpleYacc.cs

%namespace SimpleParser

%token BEGIN END TYPE CYCLE INUM RNUM ID ASSIGN SEMICOLON WHILE DO REPEAT UNTIL FOR TO IF THEN ELSE WRITE LEFT_BRACKET RIGHT_BRACKET COMMA PLUS MINUS MULT DIV LEFT_M_BRACKET RIGHT_M_BRACKET LEFT_F_BRACKET RIGHT_F_BRACKET GOTO COLON CASE BREAK SWITCH


%%


progr   :TYPE funk LEFT_M_BRACKET stlist forhead LEFT_M_BRACKET stlist forhead LEFT_M_BRACKET stlist RIGHT_M_BRACKET stlist RIGHT_M_BRACKET stlist RIGHT_M_BRACKET
        |LEFT_M_BRACKET stlist forhead LEFT_M_BRACKET stlist forhead LEFT_M_BRACKET stlist RIGHT_M_BRACKET stlist RIGHT_M_BRACKET stlist RIGHT_M_BRACKET
		;

forhead :FOR LEFT_BRACKET assign SEMICOLON eqv SEMICOLON ident ASSIGN expr RIGHT_BRACKET
        ;

funk    :ID LEFT_BRACKET RIGHT_BRACKET
        |ID LEFT_BRACKET idlist RIGHT_BRACKET
		;

dig     :RNUM
        |INUM
		;

idlist  : dig
        | ident
		| expr
		| idlist COMMA dig
		| idlist COMMA ident
		| idlist COMMA expr
		;

stlist  : statement
        | stlist statement 
		|
		;

statement: var
		 | assign SEMICOLON		 
		 | mono SEMICOLON
         ;



var     :TYPE ID SEMICOLON
        |TYPE ID ASSIGN expr SEMICOLON
        |TYPE ID LEFT_F_BRACKET dig RIGHT_F_BRACKET SEMICOLON
		|ID TYPE ID SEMICOLON
        |ID TYPE ID LEFT_F_BRACKET dig RIGHT_F_BRACKET SEMICOLON
        ;

ident 	: ID 
		;
	
assign 	: ident ASSIGN expr 
        | ident ASSIGN mono 
		;

eqv : dig ASSIGN dig
    | ident ASSIGN dig
    | dig ASSIGN ident
    | ident ASSIGN ident
	| dig ASSIGN ASSIGN dig
    | ident ASSIGN ASSIGN dig
    | dig ASSIGN ASSIGN ident
    | ident ASSIGN ASSIGN ident
    ;

expr	: T
        | dig PLUS expr
		| dig MINUS expr
		| ident PLUS expr
		| ident MINUS expr
		| expr PLUS T
		| expr MINUS T
		| dig
		;

mono    : ident PLUS PLUS
		| PLUS PLUS ident
		| ident MINUS MINUS
		| MINUS MINUS ident
		;

T		: F
		| T MULT F
		| T DIV F
		;

F		: ident  
		| dig
		| LEFT_BRACKET expr RIGHT_BRACKET
		;

bool    :eqv
        |ident
		;

%%
