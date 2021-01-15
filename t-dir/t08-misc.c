#include <stdio.h>						/*NBNCOMMENT*/

/* try to think of some pathological cases  COMMENT
 * such that the file is still lexically OK  COMMENT
 COMMENT */

#define /*NBNCOMMENT*/ my_macro(a)	\
	/*NBNCOMMENT*/ fprintf(stderr, "abc")

/* tab */		/* tab COMMENT */

int main(argc, argv)						/*NBNCOMMENT*/
	int argc;						/*NBNCOMMENT*/
	char **argv;						/*NBNCOMMENT*/

{								/*NBNCOMMENT*/
	int i, j, k;						/*NBNCOMMENT*/
/* comment COMMENT */ i = j +k;					/*NBNCOMMENT*/
/* */ func(i, /* j, */ k); /* comment COMMENT */		/*NBNCOMMENT*/

/* last line COMMENT */  while (1) printf("hello, world\n");	/*NBNCOMMENT*/

}								/*NBNCOMMENT*/
