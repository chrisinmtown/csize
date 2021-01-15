#!/bin/sh
# $RCSfile: TEST-OUT.sh,v $ 
# regression tests for csize
#
# this file checks the output of csize against the
# output generated on my machine.
#

pgm=../csize

if [ ! -f $pgm ] ; then
    echo $pgm: no such file or directory
    exit 1
fi

echo ""
echo "** Expect version information"
$pgm -v

echo "Testing program $pgm"
echo "no problems are expected for files beginning with 't' or 'v'"
echo ""
for file in t*.c v*.c
do
    echo "Input file: $file"
    $pgm -h $file
    echo ""

    echo "Compare input source as echoed back by csize with itself"
    $pgm -e $file > ${file}.echo
    echo "Diffs (expect three differences: start-line, end-line, and counts)"
    diff $file ${file}.echo
    rm -f ${file}.echo
    echo ""
done


echo ""
echo "Testing program $pgm"
echo "expect some problems for files beginning with 'z'"
echo ""
for file in z*.c
do
    echo "Input file: $file"
    $pgm -h $file
    echo ""
done

#
# file to pick on in further tests
#
guineapig=t00-hello.c

echo ""
echo "Test count of two files"
$pgm  $guineapig $guineapig

echo ""
echo "Test count of three files"
$pgm  $guineapig $guineapig $guineapig

echo ""
echo "** Expect output with headers"
$pgm -h $guineapig

echo ""
echo "** Expect echoed output"
$pgm -e $guineapig

echo ""
echo "** Expect echoed output with headers"
$pgm -eh $guineapig

echo ""
echo "** Expect usage message"
$pgm

echo ""
echo "** Expect usage message"
$pgm -h

echo "" 
echo "** Expect error: echoed file with bad char"
$pgm -e z01-bad-char.c

echo ""
echo "** Expect error: file does not exist"
$pgm z-does-not-exist.c

echo ""
echo "** Expect error: illegal option"
$pgm -u does-not-exist.c

echo ""
exit 0
