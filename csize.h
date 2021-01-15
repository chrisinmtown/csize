
#ifndef CSIZEDOTH

#define CSIZEDOTH

/*
 * $RCSfile: csize.h,v $
 *
 * csize, a program to measure the size of C source files.
 * Copyright (C) 1994 Christopher Lott
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation.  See the file COPYING for more details.
 *
 * The scanner and the functions in csize.c communicate via the global
 * variables declared here (types) and defined in the scanner (storage).
 *
 */

#ifndef _
#ifdef __STDC__
#define _(proto) proto
#else
#define _(proto) ()
#endif
#endif

extern long 
     C_newlines,
     C_blank_lines,
     C_lines_w_comments,
     C_pp_directives,
     C_nb_nc_lines,
     C_semicolons;

extern int Echo;
extern int Lex_errors;

extern void init_scanner _((FILE *, char *));
extern int yylex _((void));

#endif
