#include <stdio.h>						/*NBNCOMMENT*/
/* a multi-	COMMENT
 * line 	COMMENT
 * comment	COMMENT
 COMMENT */
struct abc {int def;						/*NBNCOMMENT*/
		};						/*NBNCOMMENT*/
       
/*brutal COMMENT */extern int *abc;				/*NBNCOMMENT*/

void func()							/*NBNCOMMENT*/
{								/*NBNCOMMENT*/
  int i, j, k;							/*NBNCOMMENT*/
  char *a, *b, *c;  /* comment COMMENT */			/*NBNCOMMENT*/

  i = j = k;							/*NBNCOMMENT*/
  /* a leading comment COMMENT */  a = b = c;			/*NBNCOMMENT*/
}								/*NBNCOMMENT*/

int main(int argc, char **argv) {				/*NBNCOMMENT*/
 int i;								/*NBNCOMMENT*/
 printf("hello, world\n");  /* a second comment COMMENT */	/*NBNCOMMENT*/
/* last comment COMMENT */
}								/*NBNCOMMENT*/
