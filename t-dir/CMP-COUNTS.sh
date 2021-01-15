#!/bin/sh
# $RCSfile: CMP-COUNTS.sh,v $
# run csize on a single file (arg 1) and compare resulting counts
#
# this file double-checks the counts obtained by csize
# using grep, awk, and wc.
#
# want an awk command at the end of each of the
# little functions to guarantee no spaces l and r
# of the number.  The test ([) program, annoyingly
# enough, declares the statement
#   abc -ne 0
# to be false, I don't understand why.  Therefore I
# treat everything as a string in order to handle 
# those cases in which an error message is returned.
#
# all nonblank noncommentary lines are marked in the
# files with NBNC
#

pgm=../csize

if [ $# -eq 0 ] ; then
    echo "usage: $0 file-name.c [ file-name.c ]"
    exit 1
fi

if [ ! -f $pgm ] ; then
    echo "$pgm: no such file or directory"
    exit 2
fi

# wc_newlines
# count new lines using wc (straightforward)
#
wc_newlines() {
    wc -l $1 | head -1 | awk '{print $1}'
}

# wc_blanklines
# use a pattern to detect blank lines then count using wc
#
wc_blanklines() {
    egrep '^[ 	]*$' $1 | wc -l | awk '{print $1}'
}

# wc_comments
# depends on the word COMMENT typed into the file
# this is a hack, but it's difficult to process 
# comments using simple text processing programs
#
# grep out COMMENT and count lines using wc
#
wc_comments() {
    egrep COMMENT $1 | wc -l | awk '{print $1}'
}

# wc_nbnc
# depends on the word NBNC typed into the file
# this is a hack, but it's difficult to detect 
# nonblank noncomment lines using simple text
# processing programs
#
# grep out NBNC and count lines using wc
#
wc_nbnc() {
    egrep NBNC $1 | wc -l | awk '{print $1}'
}

# wc_semicolons
# grep out lines where semicolons appear and count using wc
# again this is a hack and doesn't test the semicolon-recognition
# of the program very thoroughly
#
wc_semicolons() {
    cat $1 | grep ';' | wc -l | awk '{print $1}'
}
     
# wc_pp_dir
# grep out lines with a hash-mark and count using wc
#
wc_pp_dir() {
    cat $1 | grep '#' | wc -l | awk '{print $1}'
}


#
# now process all the files
#
for file in $*
do
    echo ""
    echo "Input file: $file"

    pgmline=`$pgm $file | head -1`

    pgm_newlines=`echo   $pgmline | awk '{print $1}'`
    pgm_blanklines=`echo $pgmline | awk '{print $2}'`
    pgm_comments=`echo   $pgmline | awk '{print $3}'`
    pgm_nbnc=`echo       $pgmline | awk '{print $4}'`
    pgm_semicolons=`echo $pgmline | awk '{print $5}'`
    pgm_pp_dir=`echo     $pgmline | awk '{print $6}'`

    s="$pgm_newlines"
    c=`wc_newlines $file`
    if [ "$c" != "$s" ]; then
	echo "*** Mismatch in count of new lines:  $s != $c"
    else
	echo "Matched new lines:  $s = $c"
    fi
    
    s="$pgm_blanklines"
    c=`wc_blanklines  $file`
    if [ "$c" != "$s" ]; then
	echo "*** Mismatch in count of blank lines:  $s != $c"
    else
	echo "Matched blank lines:  $s = $c"
    fi
    
    s="$pgm_comments"
    c=`wc_comments $file`
    if [ "$c" != "$s" ]; then
	echo "*** Mismatch in count of comments:  $s != $c"
    else
	echo "Matched comments:  $s = $c"
    fi
    
    s="$pgm_nbnc"
    c=`wc_nbnc $file`
    if [ "$c" != "$s" ]; then
	echo "*** Mismatch in count of nonblank noncomment lines:  $s != $c"
    else
	echo "Matched nonblank noncomment lines:  $s = $c"
    fi
    
    s="$pgm_semicolons"
    c=`wc_semicolons $file`
    if [ "$c" != "$s" ]; then
	echo "*** Mismatch in count of semicolons:  $s != $c"
    else
	echo "Matched semicolons:  $s = $c"
    fi
    
    s="$pgm_pp_dir"
    c=`wc_pp_dir  $file`
    if [ "$c" != "$s" ]; then
	echo "*** Mismatch in count of preprocessor directives:  $s != $c"
    else
	echo "Matched pp directives:  $s = $c"
    fi
    
done
