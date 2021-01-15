
/* grep doesn't see a nl at the end of the           COMMENT
   next line, so when it feeds that line to          COMMENT
   wc to count semicolons, it fails.  therefore,     COMMENT
   the next line has a semicolon to make the count   COMMENT
   count come out right ;			     COMMENT 
   also messes up nbnc lines			     COMMENT */
char *s = "123";   /*NBNCOMMENT*/
