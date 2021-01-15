
/* test processing of string literals 		COMMENT */
/* especialy continuation lines			COMMENT */


char *s = "NBNC";

char *t = "NBNC\
	   NBNC";

char *u = "NBNC\
	   NBNC\
	   NBNC";

char *v = "NBNC\
	   NBNC\
	   NBNC\
	   NBNC";

char *w = "NBNC\
	   NBNC\
	   NBNC"
	;			/*NBNCOMMENT*/

char *x = "NBNC\
	   NBNC\\\
	   NBNC";

char *y = "NBNC \"what's up, doc\"";

char *z = "\\";   /*NBNCOMMENT*/
