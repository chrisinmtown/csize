
#    define zero 0						/*NBNCOMMENT*/
#	undef pi						/*NBNCOMMENT*/
#include <stdio.h>						/*NBNCOMMENT*/
 # include <unistd.h>						/*NBNCOMMENT*/
# line 10 "abc"							/*NBNCOMMENT*/
# error 1 != 0 							/*NBNCOMMENT*/

#pragma  I don't know what I'm doing				/*NBNCOMMENT*/
#pragma  who came up with the word pragma anyhow		/*NBNCOMMENT*/

   #if 0 							/*NBNCOMMENT*/
#else 								/*NBNCOMMENT*/
#ifdef fault-free						/*NBNCOMMENT*/
	#elif 							/*NBNCOMMENT*/
#ifndef abcd 							/*NBNCOMMENT*/
 #endif 							/*NBNCOMMENT*/
#else a								/*NBNCOMMENT*/

printf(";;hello;\" world\n"); 					/*NBNCOMMENT*/

/* now some pp directives that appear to be in use out there COMMENT */
#include_next abc						/*NBNCOMMENT*/
# include_next abc						/*NBNCOMMENT*/
 # include_next abc						/*NBNCOMMENT*/
 #	include_next abc					/*NBNCOMMENT*/
# import							/*NBNCOMMENT*/
#warning i am opening the pod bay doors, dave			/*NBNCOMMENT*/
#sccs "version 1.3.3.5.1 patchlevel 1239"			/*NBNCOMMENT*/
#ident "this apparently hands an identifier to the assembler"   /*NBNCOMMENT*/
# assert pi = 3.14						/*NBNCOMMENT*/
 #unassert fault-free						/*NBNCOMMENT*/

# error use the force, luke					/*NBNCOMMENT*/

int main(int argc, char **argv) {				/*NBNCOMMENT*/
 int i;								/*NBNCOMMENT*/
 char *s;							/*NBNCOMMENT*/
 i = ';';							/*NBNCOMMENT*/
 s = ";";							/*NBNCOMMENT*/
}								/*NBNCOMMENT*/

#if 0								/*NBNCOMMENT*/
/* unfortunately, this has to be code also  COMMENT
 COMMENT */
#endif								/*NBNCOMMENT*/

/* test 1 continuation line				COMMENT */
#define NBNC\
	NBNC

/* test 2 continuation lines				COMMENT */
#define NBNC\
	NBNC\
	NBNC

/* test processing of double backslashes		COMMENT */
#define NBNC \\

#define NBNC a\\b\\c 
