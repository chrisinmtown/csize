#include <stdio.h>
#include <unistd.h>

#include "csize.h"


/*
 * $RCSfile: v-csize.c,v $
 *
 * csize, a program to measure the size of C source files.
 * Copyright (C) 1994 Christopher Lott <lott@informatik.uni-kl.de>
 * FB Informatik - Bau 57 / Universitaet KL / D--67653 Kaiserslautern / Germany
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation.  See the file COPYING for more details.
 *
 * This file holds functions to open files, add total counts,
 * and print summaries.  All the real work is done in the scanner.
 * All global variables are likewise declared in the scanner;
 * they are also declared externally in the the header file.
 *
 */

void print_results(long nl, 
		   long bl, 
		   long lwc, 
		   long nbncl, 
		   long semi, 
		   long pp, 
		   char *filename)
{
  (void) printf("%8ld %8ld %8ld %8ld %8ld %8ld %s\n",
	 nl, bl, lwc, nbncl, semi, pp, filename);
}


int process_file(char *filename)
{
  FILE *fp;
  int rc;

  fp = fopen(filename, "r");
  if (fp == NULL) {
    perror(filename);
    rc = -1;
  }
  else {
    if (Echo) (void) printf("--start of file--\n");
    /* process the input */
    init_scanner(fp, filename);
    while (yylex() != 0)
      ;
    if (Echo) (void) printf("--end of file--\n");
    (void) fclose(fp);
    rc = Lex_errors;
  }

  return rc;
}


int main(int argc, char ** argv)
{
  extern int optind;

  int c, 
      rc,
      errflg = 0, 
      hflg = 0,
      nfiles = 0;
  long total_newlines = 0, 
       total_blank_lines = 0, 
       total_lines_w_comments = 0,
       total_nb_nc_lines = 0,
       total_semicolons = 0,
       total_pp_directives = 0;

  while ((c = getopt(argc, argv, "eh")) != -1)
    switch (c) {
    case 'e':
      ++Echo;
      break;
    case 'h':
      ++hflg;
      break;
    default:
      ++errflg;
    }
  if (argc == 1 || optind == argc || errflg) {
    (void)fprintf(stderr, "usage: %s [ -eh ] file.c [ file.c ... ]\n", *argv);
    (void)fprintf(stderr, "       -e == echo the input files\n");
    (void)fprintf(stderr, "       -h == print a header before the data\n");
    rc = -1;
  }
  else {
    for (; optind < argc; optind++) {
      rc = process_file(argv[optind]);
      if (rc == 0) {
	if (hflg) {
	  (void)printf("   total    blank lines w/   nb, nc    semi- preproc. file\n");
	  (void)printf("   lines    lines comments    lines   colons  direct.\n");
	  (void)printf("--------+--------+--------+--------+--------+--------+----\n");
	  hflg = 0;  /* only print the header once */
	}
	print_results(C_newlines, C_blank_lines, C_lines_w_comments, 
		      C_nb_nc_lines, C_semicolons, C_pp_directives, 
		      argv[optind]);
	total_newlines         += C_newlines;
	total_blank_lines      += C_blank_lines;
	total_lines_w_comments += C_lines_w_comments;
	total_nb_nc_lines      += C_nb_nc_lines;
	total_semicolons       += C_semicolons;
	total_pp_directives    += C_pp_directives;
	++nfiles;
      }
    }
    if (nfiles > 1) {
      print_results(total_newlines, total_blank_lines, 
		    total_lines_w_comments, total_nb_nc_lines,
		    total_semicolons, total_pp_directives, "total");
    }
  }
  return rc;
}
