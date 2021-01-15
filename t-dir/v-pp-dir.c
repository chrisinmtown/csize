
/* test blank continuation lines in preprocessor directives */
/* it's impossible to hardwire this case for grep because the */
/* continuation line really has to be blank */

/* use a totally blank continuation line */
#define a d\

/* use a whitespace continuation line */
#define a d\
    
/* use a whitespace continuation line */
#define a d\
	
/* use a whitespace continuation line as the last line*/
#define a d\
	puts("abc"); \
	puts("abc"); \

