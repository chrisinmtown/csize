/* From: Scott Quier <scott@saisun13.larc.nasa.gov>		COMMENT */
/* The following allows for the implementation of function 	COMMENT */
/* prototypes without limiting the compile to just ANSI 	COMMENT */
/* compliant compilers.  I sometimes have the need to compile	COMMENT */
/* with the Sun kernal compiler (cc)				COMMENT */

#ifdef PROTO							/*NBNCOMMENT*/
#undef PROTO							/*NBNCOMMENT*/
#endif								/*NBNCOMMENT*/

/* This is defined by any ANSI compliant compiler 		COMMENT */
#ifdef __STDC__							/*NBNCOMMENT*/
#define PROTO(x) x						/*NBNCOMMENT*/
#else								/*NBNCOMMENT*/
#define PROTO(x) ()						/*NBNCOMMENT*/
#endif								/*NBNCOMMENT*/

/* Generate the function prototype as best we can		COMMENT */
/* given the limitations of the compiler			COMMENT */
int main							/*NBNCOMMENT*/
 PROTO((int argc, char *argv[]));				/*NBNCOMMENT*/

/* Two different ways to define the function interface 		COMMENT */
#ifdef __STDC__							/*NBNCOMMENT*/
int main(int argc, char *argv[])				/*NBNCOMMENT*/
#else								/*NBNCOMMENT*/
int main(argc, argv)						/*NBNCOMMENT*/
int argc;							/*NBNCOMMENT*/
char *argv[];							/*NBNCOMMENT*/
#endif								/*NBNCOMMENT*/
{								/*NBNCOMMENT*/
   printf("Hello, World\n");					/*NBNCOMMENT*/
}								/*NBNCOMMENT*/
