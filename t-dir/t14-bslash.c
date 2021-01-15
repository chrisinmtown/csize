
/* backslashes are not handled very gracefully, but		COMMENT
   they are accepted.						COMMENT */


/*NBNCOMMENT*/	int abc\
	def;							/*NBNCOMMENT*/

/* should evaluate to 					COMMENT */

	int abcdef;						/*NBNCOMMENT*/
