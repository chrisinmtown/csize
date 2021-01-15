# csize

This repository holds the code for csize, a program that measures the
size of C programs.  See the [csize man page](csize.man.txt) for
a detailed discussion of the measures, their definitions, and their
pitfalls.  No complexity measures are computed.

The measures are purely syntactical; the program has no understanding of
the C grammar.  Measures such as declaration or executable statement counts
require an understanding of the semantics of C.  Although these measures
would be valuable, computing them would require the scanner to differentiate
between /identifiers/ and /type names/; i.e., csize would need the type
system from a C compiler.  See p. 234 of Kernighan and Ritchie, 2nd edn.,
2nd paragraph, 2nd-to-last sentence. 

The scanner-generator flex is required; see the INSTALL file for the
exact version that is required.  I use flex to generate a scanner that
recognizes tokens from the C language.  The scanner is arguably
underutilized.  However, I much prefer using flex because I think it
makes the code which I must write far simpler to maintain.  The code
size is hardly a problem, and I don't think that I can generate a
scanner that runs faster than a flex scanner.  The file scan.l holds
the source used by flex to generate the scanner for C.  The old unix
utility lex will not work; it complains about the file: 
	"scan.l", line 401: (Error) Too many right contexts 
If you simply remove the first token ("auto"), then lex dumps core on
my machine.  Neither behavior is acceptable and I refuse to code
around bugs in lex when flex is available, reliable, and free.

The foundation for this code was a rudimentary C parser distributed 
originally by Jeff Lee (see README attached below).  The scan.h file
in this distribution was actually generated by yacc from that grammar.


----- Begin: README from Jeff Lee

The files in this directory contain the ANSI C grammar from the April 30, 1985
draft of the proposed standard. This copy also incorporates all bug fixes I
have seen since the last two postings. With a little work this grammar can
be made to parse the C that most of us know and love (sort of).

There is one bug fix to the grammar that is in this posting. On line 295
of gram.y it previously read declaration_specifiers instead of
type_specifier_list as it does now. I believe the folks at the ANSI committee
made a mistake since if you replace the line with what the original read
you will end up with 16 shift/reduce errors and 2 reduce/reduce errors
(the good ones). As it is, it only has 1 shift/reduce error that occurs
on the if/else construct. YACC creates the correct parser and I don't want
to ugly my grammar up.

Anyway, all cumquats unite and generate this sucker. Then just sit and play
with it. Remember, the grammar accepts things like

	"Hello, world"++;
	--1.23456;
	*'a'

but this is not a bug, but simply a shuffling of the checking into the
semantic analysis. If you want to hack it up to do lvalue and rvalue
checking, I'm sure the ANSI committee would be glad to have your changes.
Don't send'em to me though. I don't want'em. Wear this in good health.

Jeff Lee
gatech!jeff	jeff@gatech	jeff%gatech.CSNet@CSNet-Relay.ARPA

----- End: README from Jeff Lee
