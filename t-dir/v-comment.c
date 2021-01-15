
/* test treatment of blank lines within comments
 * they should be counted as lines with comments,
 * not as blank lines
 * Next line has nothing:

 * Next line has 1 space:
 
 * Next line has 1 tab:
	
 * Next line has some of both:
  	  
 * that's all she wrote
 * Results should report that this file has 2 blank lines
 */

