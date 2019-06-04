%using SimpleParser;
%using QUT.Gppg;
%using System.Linq;

%namespace SimpleScanner

Alpha 	[a-zA-Z_]
Digit   [0-9] 
AlphaDigit {Alpha}|{Digit}
INTNUM  {Digit}+
REALNUM {INTNUM}\.{INTNUM}
ID {Alpha}{AlphaDigit}* 

%%

{INTNUM} { 
  return (int)Tokens.INUM; 
}

{REALNUM} { 
  return (int)Tokens.RNUM;
}

{ID}  { 
  int res = ScannerHelper.GetIDToken(yytext);
  return res;
}

">" { return (int)Tokens.ASSIGN; }
"<" { return (int)Tokens.ASSIGN; }
"=" { return (int)Tokens.ASSIGN; }
":=" { return (int)Tokens.ASSIGN; }
"("  { return (int)Tokens.LEFT_BRACKET; }
")"  { return (int)Tokens.RIGHT_BRACKET; }
"{"  { return (int)Tokens.LEFT_M_BRACKET; }
"}"  { return (int)Tokens.RIGHT_M_BRACKET; }
"["  { return (int)Tokens.LEFT_F_BRACKET; }
"]"  { return (int)Tokens.RIGHT_F_BRACKET; }
","  { return (int)Tokens.COMMA; }
"+"  { return (int)Tokens.PLUS; }
"-"  { return (int)Tokens.MINUS; }
"*"  { return (int)Tokens.MULT; }
"/"  { return (int)Tokens.DIV; }
";"  { return (int)Tokens.SEMICOLON;}
":"  { return (int)Tokens.COLON;}

[^ \r\n] {
	LexError();
	return (int)Tokens.EOF; // ����� �������
}

%{
  yylloc = new LexLocation(tokLin, tokCol, tokELin, tokECol); // ������� ������� (������������� ��� ���������������), ������������ @1 @2 � �.�.
%}

%%

public override void yyerror(string format, params object[] args) // ��������� �������������� ������
{
  var ww = args.Skip(1).Cast<string>().ToArray();
  string errorMsg = string.Format("({0},{1}): ��������� {2}, � ��������� {3}", yyline, yycol, args[0], string.Join(" ��� ", ww));
  throw new SyntaxException(errorMsg);
}

public void LexError()
{
	string errorMsg = string.Format("({0},{1}): ����������� ������ {2}", yyline, yycol, yytext);
    throw new LexException(errorMsg);
}

class ScannerHelper 
{
  private static Dictionary<string,int> keywords;

  static ScannerHelper() 
  {
    keywords = new Dictionary<string,int>();
	keywords.Add("int",(int)Tokens.TYPE);
	keywords.Add("double",(int)Tokens.TYPE);
	keywords.Add("void",(int)Tokens.TYPE);
    keywords.Add("begin",(int)Tokens.BEGIN);
    keywords.Add("end",(int)Tokens.END);
    keywords.Add("cycle",(int)Tokens.CYCLE);
	keywords.Add("while", (int)Tokens.WHILE);
	keywords.Add("do", (int)Tokens.DO);
	keywords.Add("repeat", (int)Tokens.REPEAT);
	keywords.Add("until", (int)Tokens.UNTIL);
	keywords.Add("for", (int)Tokens.FOR);
	keywords.Add("to", (int)Tokens.TO);
	keywords.Add("if", (int)Tokens.IF);
	keywords.Add("then", (int)Tokens.THEN);
	keywords.Add("else", (int)Tokens.ELSE);
	keywords.Add("write", (int)Tokens.WRITE);
	keywords.Add("goto", (int)Tokens.GOTO);
	keywords.Add("case", (int)Tokens.CASE);
	keywords.Add("break", (int)Tokens.BREAK);
	keywords.Add("switch", (int)Tokens.SWITCH);
  }
  public static int GetIDToken(string s)
  {
    if (keywords.ContainsKey(s.ToLower())) // ���� �������������� � ��������
      return keywords[s];
    else
      return (int)Tokens.ID;
  }
}
