
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*
ws			[ \t\v\f]
nl			[\n]

%{

/* $RCSfile: scan.l,v $
 *
 * csize, a program to measure the size of C source files.
 * Copyright (C) 1994 Christopher Lott
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation.  See the file COPYING for more details.
 *
 * This file holds the source used by flex to generate the scanner for C.
 * SEE THE FILE "INSTALL" FOR THE REQUIRED FLEX VERSION.  Sorry to
 * shout, but different versions of flex exhibit different behavior.  
 *
 * Why flex?  Because lex complains about this file as follows:
 *     "scan.l", line xxx: (Error) Too many right contexts
 * If you simply remove the first token ("auto"), then lex dumps core
 * on my machine.  Neither behavior is acceptable and I refuse to code
 * around bugs in lex when flex is available, reliable, and free.
 *
 */

#include <stdio.h>
#include <scan.h>
#include <csize.h>

/* variables supplied by flex
 *
 */

extern yy_size_t yyleng;
extern char *yytext;
extern FILE *yyin;

/* global variables
 * variables beginning with C_ are referenced in main and
 * Echo is set in main; all appear in csize.h
 *
 */

int  Echo, 
     Lex_errors;

long C_newlines,           /* incremented at the *end* of a line */
     C_blank_lines,
     C_lines_w_comments,   
     C_nb_nc_lines,        /* incremented when first nbnc is seen */
     C_semicolons,
     C_pp_directives;

/*
 * variables used only in this file
 */

static char *Filename;
static int Column;
static long prev_line_with_text;
static long prev_line_with_comment;

/*
 * functions defined and used only in this file
 */

static int check_type _((void));
static void count_nb_nc_lines _((void));
static void count _((void));
static void semicolon _((void));
static void string_lit _((void));
static void count_line_w_comment _((void));
static void comment _((int));
static void pp_dir _((void));
static void count_ws _((void));
static void whitespace_line _((void));
static void newline _((void));
static void scan_error _((char *));
static void bad_char _((void));

%}

%%

"auto"			{ count(); return(AUTO);     }
"break"			{ count(); return(BREAK);    }
"case"			{ count(); return(CASE);     }
"char"			{ count(); return(CHAR);     }
"const"			{ count(); return(CONST);    }
"continue"		{ count(); return(CONTINUE); }
"default"		{ count(); return(DEFAULT);  }
"do"			{ count(); return(DO);       }
"double"		{ count(); return(DOUBLE);   }
"else"			{ count(); return(ELSE);     }
"enum"			{ count(); return(ENUM);     }
"extern"		{ count(); return(EXTERN);   }
"float"			{ count(); return(FLOAT);    }
"for"			{ count(); return(FOR);      }
"goto"			{ count(); return(GOTO);     }
"if"			{ count(); return(IF);       }
"int"			{ count(); return(INT);      }
"long"			{ count(); return(LONG);     }
"register"		{ count(); return(REGISTER); }
"return"		{ count(); return(RETURN);   }
"short"			{ count(); return(SHORT);    }
"signed"		{ count(); return(SIGNED);   }
"sizeof"		{ count(); return(SIZEOF);   }
"static"		{ count(); return(STATIC);   }
"struct"		{ count(); return(STRUCT);   }
"switch"		{ count(); return(SWITCH);   }
"typedef"		{ count(); return(TYPEDEF);  }
"union"			{ count(); return(UNION);    }
"unsigned"		{ count(); return(UNSIGNED); }
"void"			{ count(); return(VOID);     }
"volatile"		{ count(); return(VOLATILE); }
"while"			{ count(); return(WHILE);    }

{L}({L}|{D})*		{ count(); return(check_type()); }

0[xX]{H}+{IS}?		{ count(); return(CONSTANT); }
0{D}+{IS}?		{ count(); return(CONSTANT); }
{D}+{IS}?		{ count(); return(CONSTANT); }
'(\\.|[^\\'\n])+'	{ count(); return(CONSTANT); }

{D}+{E}{FS}?		{ count(); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}?	{ count(); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}?	{ count(); return(CONSTANT); }

">>="			{ count(); return(RIGHT_ASSIGN); }
"<<="			{ count(); return(LEFT_ASSIGN); }
"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
"&="			{ count(); return(AND_ASSIGN); }
"^="			{ count(); return(XOR_ASSIGN); }
"|="			{ count(); return(OR_ASSIGN); }
">>"			{ count(); return(RIGHT_OP); }
"<<"			{ count(); return(LEFT_OP); }
"++"			{ count(); return(INC_OP); }
"--"			{ count(); return(DEC_OP); }
"->"			{ count(); return(PTR_OP); }
"&&"			{ count(); return(AND_OP); }
"||"			{ count(); return(OR_OP); }
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }
";"			{ count(); semicolon(); return(';'); }
"{"			{ count(); return('{'); }
"}"			{ count(); return('}'); }
","			{ count(); return(','); }
":"			{ count(); return(':'); }
"="			{ count(); return('='); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
"["			{ count(); return('['); }
"]"			{ count(); return(']'); }
"."			{ count(); return('.'); }
"&"			{ count(); return('&'); }
"!"			{ count(); return('!'); }
"~"			{ count(); return('~'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }
"^"			{ count(); return('^'); }
"|"			{ count(); return('|'); }
"?"			{ count(); return('?'); }

\"			{ count(); string_lit(); return(STRING_LITERAL); }

"#"{ws}*"define"	{ count(); pp_dir(); /* from K&R 2/e p. 239 */ }
"#"{ws}*"undef"		{ count(); pp_dir(); }
"#"{ws}*"include"	{ count(); pp_dir(); }
"#"{ws}*"line"		{ count(); pp_dir(); }
"#"{ws}*"error"		{ count(); pp_dir(); }
"#"{ws}*"pragma"	{ count(); pp_dir(); }

"#"{ws}*"endif"		{ count(); pp_dir(); }
"#"{ws}*"if"		{ count(); pp_dir(); }
"#"{ws}*"ifdef"		{ count(); pp_dir(); }
"#"{ws}*"ifndef"	{ count(); pp_dir(); }
"#"{ws}*"elif"		{ count(); pp_dir(); }
"#"{ws}*"else"		{ count(); pp_dir(); }

"#"{ws}*"include_next"	{ count(); pp_dir(); /* from GCC's cccp.c */ }
"#"{ws}*"import"	{ count(); pp_dir(); }
"#"{ws}*"warning"	{ count(); pp_dir(); }
"#"{ws}*"sccs"		{ count(); pp_dir(); }
"#"{ws}*"ident"		{ count(); pp_dir(); }
"#"{ws}*"assert"	{ count(); pp_dir(); }
"#"{ws}*"unassert"	{ count(); pp_dir(); }

"\\"			{ count(); /* backslash processing is weak */ }

"/*"			{ comment(1); }
{ws}+			{ count_ws(); }
^{ws}+$			{ whitespace_line(); }
{nl}			{ newline(); }
.			{ bad_char(); }

%%

/* If being compiled with a C++ compiler, 
 * then the flex input function is named 
 * "yyinput"; else it's named "input".
 *
 * Only tested with g++.
 *
 */

#ifdef __cplusplus
#define input yyinput
#endif

/* init_scanner
 * initialize necessary variables and set up the input file pointer
 * before processing a file.
 *
 * Called from csize.c
 *
 */

void
init_scanner(FILE *fp, char *filename) 
{
  C_newlines    = 0;
  C_blank_lines = 0;
  C_lines_w_comments = 0;
  C_nb_nc_lines = 0;
  C_semicolons = 0;
  C_pp_directives = 0;

  Lex_errors = 0;
  prev_line_with_comment = -1;
  prev_line_with_text    = -1;

  Filename = filename;

  /* although the flex documentation states that assigning
   * to yyin like this:
   *         yyin = fp;
   * should be equivalent to 
   *         yyrestart(fp);
   * the run-time behavior of scanners generated with flex 2.4.7
   * does not conform to that specification.  If  only the assignment
   * is used, the scanner complains of an illegal characater at line 1, 
   * character 1 of subsequent files.  Anyhow, this works, and I did
   * not test to see if the bug was fixed in subsequent versions
   * because I preferred this version.
   */
  yyrestart(fp); 
}


/* count_nb_nc_lines
 * count nonblank noncomment lines in the input, but
 * ensure that we don't count the same line twice by
 * checking and/or updating the appropriate variable
 *
 * called by functions; no dependence on yytext
 *
 */

static void
count_nb_nc_lines(void)
{
  if (C_newlines != prev_line_with_text) {
    ++C_nb_nc_lines;
    prev_line_with_text = C_newlines;
  }
}


/* count
 * count columns for lines with *nonblank noncomment* text.
 * Optionally echo the buffer yytext, and call count_nb_nc_lines  
 * to count the line.
 *
 * called by lexer with the *nonblank noncomment* token in yytext
 *
 */

static void
count(void)
{
  Column += yyleng;
  if (Echo) 
    ECHO;
  count_nb_nc_lines();
}


/* semicolon
 * saw a semicolon in the input, just bump the appropriate counter
 * 
 * count() is called before this function
 *
 * called by lexer but has no dependence on yytext
 *
 */

static void
semicolon(void)
{
  ++C_semicolons;
}


/* pp_dir
 * Read characters until the terminating newline ('\n') is found.  Count the
 * number of directives.  Even though no text may appear after a directive 
 * on a line, count columns so that the function newline() can be used.
 *
 * Complications:
 *     Escaped backslash characters ('\\').  These do nothing.
 *     Escaped newline characters (continuation lines).  These force the
 *         function to update newline and nonblank noncomment line counts.  
 *         Note that a continuation line can consist of a single newline,
 *         or only whitespace and a newline; in both cases the continuation
 *         line terminates the preprocessor directive.  The algorithm makes 
 *         provisions to treat both cases identically.  Those blank-ish 
 *         continuation lines, although they look blank, are counted as 
 *         nonblank noncomment lines.
 *     Comments that begin on the pp_dir's line.  These must be processed
 *         until the closing * and / is found, after which processing of 
 *         the pp resumes.  See the part in K&Rrev2, p. 229, about 
 *         logically successive preprocessor phases.
 *     The terminating newline must be given back via unput so that
 *         the lexer can correctly identify the beginning of lines
 *         for rules that use the caret ('^')
 *
 * Input errors:
 *     EOF condition before the terminating newline
 * 
 * count() is called before this function, which marks the first line of
 *     the preprocessor directive as having nonblank noncomment text.  
 *
 * Called by the lexer, but no dependence on yytext
 *
 */

static void
pp_dir(void)
{
  register int c;
  register int in_pp_dir = 1;
  register int saw_forwslash = 0;
  register int apply_backslash = 0;
  
  ++C_pp_directives;

  while (in_pp_dir && (c = input()) != EOF) {

    if (c == '\n') {             /* first take care of newline chars */
      if (apply_backslash) {
	apply_backslash = 0;
	newline();               /* register the newline globally */
	count_nb_nc_lines();     /* count the new nb nc line */
      }
      else {
	if (Column == 0)         /* if Column has value 0, newline() will */
	  ++Column;              /* count the line as blank; don't let it */
	unput(c);                /* give back the nl */
	in_pp_dir = 0;           /* done with this pp dir */
      }
    }
    else {

      if (Echo)                  /* only do echo processing for non-newlines */
	putchar(c);
      ++Column;

      switch (c) {
      case '\\':
	if (apply_backslash) {
	  apply_backslash = 0;
	}
	else {
	  apply_backslash = 1;
	}
	saw_forwslash = 0;
	break;
      case '/':
	saw_forwslash = 1;
	apply_backslash = 0;
	break;
      case '*':
	if (saw_forwslash) {
	  comment(0);             /* 0 means don't echo the start token again */
	}
	saw_forwslash = 0;
	apply_backslash = 0;
	break;
      default:   
	apply_backslash = 0;      /* any char after f/b-slash turns off the flags */
	saw_forwslash = 0;
	break;
      }
    }

  } /* while */

  if (c == EOF)
    scan_error("EOF in preprocessor directive");
}


/* string_lit
 * Read characters until the closing quote ('"') is found.  Do not count
 * string literals. Count columns because a string literal may be followed 
 * by other text on a line. 
 *
 * Complications:
 *     Escaped backslash characters ('\\').  These do nothing.
 *     Escaped quote characters ('\"').  These do not terminate
 *         the string literal.
 *     Escaped newline characters (continuation lines).  These force the
 *         function to update newline and nonblank noncomment line counts.  
 *         Note that a continuation line can never be entirely blank - 
 *         either it has another escaped newline, or it has the terminating 
 *         quote.  This prevents the anomaly of counting a blank line as
 *         something else, as is the case for preprocessor directives.
 *
 * Input errors:
 *     unescaped newline before the terminating quote
 *     EOF condition     before the terminating quote
 * 
 * count() is called before this function, which marks the first line of
 *     the string literal line as having nonblank noncomment text.  
 *
 * Called by the lexer, but no dependence on yytext
 *
 */

static void
string_lit(void)
{
  register int c;
  register int in_string_lit = 1;
  register int apply_backslash = 0;  /* apply backslash to the next char seen */

  while (in_string_lit && (c = input()) != EOF) {

    if (c == '\n') {             /* first take care of newline chars */
      if (apply_backslash) {
	apply_backslash = 0;
	newline();               /* register the newline globally */
	count_nb_nc_lines();     /* count the new nb nc line */
      }
      else {
	scan_error("newline in string literal");
	unput(c);                /* give back the newline */
	in_string_lit = 0;       /* give up on this string literal */
      }
    }
    else {                       /* prev char was not a newline */
      switch (c) {
      case '\\':
	if (apply_backslash) 
	  apply_backslash = 0;
	else
	  apply_backslash = 1;
	break;
      case '"':
	if (apply_backslash) 
	  apply_backslash = 0;
	else
	  in_string_lit = 0;     /* finished with this string literal */
	break;
      default:   
	if (apply_backslash)     /* any char after bslash turns off the flag */
	  apply_backslash = 0;
	break;
      }

      if (Echo)                  /* only do echo processing for non-newlines */
	putchar(c);
      ++Column;
    }

  } /* while */

  if (c == EOF)
    scan_error("EOF in string literal");
}


/* count_ws
 * count the columns in the buffer yytext (only white space, never nl)
 * adjusting for tabs 
 *
 * called by the lexer with the whitespace in yytext
 *
 */

static void
count_ws(void)
{
  register int i;
  
  if (Echo) 
    ECHO;

  for (i = 0; yytext[i] != '\0'; i++)
    if (yytext[i] == '\t')
      Column += 8 - (Column % 8);
    else
      Column++;
}  


/* whitespace_line
 * Process a line that is not empty but only has whitespace.
 * The newline is *not* part of yytext at this point.
 * Do not do *anything* except echo the line, if desired.
 * Because the Column variable is not changed, it will be
 * 0 when newline is called, which will count the blank line.
 *
 * called by the lexer with the whitespace in yytext
 *
 */

static void
whitespace_line(void)
{
  if (Echo) 
    ECHO;
}


/* newline
 * Count all newline characters.  Also check the value of the Column 
 * variable to catch lines with nothing but whitespace (blank lines).
 * 
 * Note that blank lines are somewhat difficult to catch with a lex 
 * pattern, because the pattern ``^"\n"'', meaning match a newline that 
 * occurs first on a line, doesn't seem to work.
 *
 * Note also that if the lex pattern to match a line with only whitespace
 * fires, then the Column variable will not be incremented, and this 
 * function will be called with Column = 0.  I call this a virtual 
 * column 0, because newline really didn't occur as the first character
 * on the line, we just pretend that it did.
 *
 * Called by the lexer *and* other functions; no dependence on yytext
 *
 */

static void
newline(void)
{
  if (Echo) 
    putchar('\n');
  ++C_newlines;
  if (Column == 0) {
    ++C_blank_lines;
  }
  Column = 0;
}


/* count_line_w_comment
 * Cuarantee that we don't count a line as having a comment twice
 *
 * Called by functions; no dependence on yytext
 *
 */

static void
count_line_w_comment(void)
{
  if (C_newlines != prev_line_with_comment) {
    ++C_lines_w_comments;
    prev_line_with_comment = C_newlines;
  }
}


/* comment
 * Read characters until the closing two-character sequence '*' and '/'
 * is found.  Count the lines with comments.  Count columns because a 
 * comment may be followed by other text on a line.
 *
 * Complications:
 *     Newline characters.  These force the function to update the counts
 *         of newlines and the number of lines with comments.  A line
 *         within a comment that has zero or more whitespace characters 
 *         and a newline, although blank, will be counted as a comment line.
 * Input errors:
 *     EOF condition before the terminating token
 * 
 * This fn implements a simple FSA to recognize the end of a comment.
 * The original code was reused from Jeff Lee's distribution and
 * amended to count lines.  While I don't much like gotos, his 
 * implementation is highly concise and keeps code redundancy to a 
 * minimum.  This code is far more concise than, for example, the 
 * code from the flexdoc(1) man page, when you consider all the
 * intermediate cases in which characters must be counted.
 *
 * Called by the lexer with the comment start token in yytext,
 * and also called by pp_dir with garbage in yytext, so don't
 * depend on yytext (and don't use ECHO).  Argument tells whether
 * it should echo the comment start token.
 *
 */

static void
comment(int echo_start)
{
  register int c;
  int lookahead;

  if (Echo && echo_start) { 
    putchar('/');
    putchar('*');
  }
  Column += yyleng;

  /* starting a comment, count the line if necessary */
  count_line_w_comment();
  
  /* deal with all characters in this while loop */
 loop:
  while ((c = input()) != EOF) {    /* find a star */

    if (c == '\n') {
      if (Column == 0)      /* if Column has value 0, newline() will count */
	++Column;           /* the line as blank, which we don't want */
      newline();
      count_line_w_comment();
    }
    else {
      if (Echo) 
	putchar(c);
      ++Column;
    }

    if (c == '*')                   /* found one, leave the while loop */
      break;
  }

  if (c != EOF && (lookahead = input()) != '/') {    /* check for a slash */
    unput(lookahead);
    goto loop;
  }

  if (c == EOF) {
    scan_error("EOF in comment");
  }
  else {
    if (Echo) 
      putchar('/');
  }
}


/* check_type
 * pseudo code --- this is what it should check
 *
 *	if (yytext == type_name)
 *		return(TYPE_NAME);
 *	else
 *		return(IDENTIFIER);
 *
 * If it did, it would be easy to build a C language
 * recognizer, and then trivial to count declarations
 * and executable statements.
 *
 * However, the function only returns IDENTIFIER
 *
 */

static int
check_type(void)
{
  return(IDENTIFIER);
}


/* scan_error
 * print an informative error message with file, line info.
 * if echoing is on, indicate the column where the error
 * was found by using the Column variable
 *
 */

static void
scan_error(char *s)
{
  fflush(stdout);
  ++Lex_errors;
  if (Echo)
    printf("\n%*s\n%*s\n", Column, "^", Column, s);
  else
    printf("\"%s\", line %ld: %s\n", Filename, C_newlines + 1, s);
}


/* bad_char
 * bump up the column count and call the error function
 *
 * Called by the lexer with the unrecognized character in yytext
 *
 */

static void
bad_char(void)
{
  register int i;

  if (Echo)
    ECHO;
  ++Column;
  scan_error("bad character");
  if (Echo) /* restore output to column where we left off */
    for (i = 0; i < Column; ++i)
      putchar(' ');
}


/* yywrap
 * supply a trivial version of yywrap
 * to eliminate the need to link against libfl
 * the value 1 means stop at the end of the file
 * (the file pointer has not been aimed at a new file)
 *
 * Called by the lexer at the end of the input
 *
 */

int
yywrap(void)
{
  return 1;
}
