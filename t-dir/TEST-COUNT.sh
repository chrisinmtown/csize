#!/bin/sh
# $RCSfile: TEST-COUNT.sh,v $
# regression tests for csize
#

pgm=../csize
tester=./CMP-COUNTS.sh

if [ ! -f $pgm ] ; then
    echo $pgm: no such file or directory
    exit 1
fi


echo "Testing program $pgm"
echo "expect some errors for input files that begin with 'z'"
echo "(this makes sure that the test scaffold detects errors)"
for file in t*.c z*.c
do
    $tester $file
done

echo ""
echo "Test count of two files"
s=`$pgm  t00-hello.c t00-hello.c | tail -1 | awk '{print $1}'`
c=`wc -l t00-hello.c t00-hello.c | tail -1 | awk '{print $1}'`
if [ "$c" != "$s" ]; then
    echo "*** Mismatch in count of newlines; $s != $c"
else
    echo "Matched newlines: $s = $c"
fi

echo ""
echo "Test count of three files"
s=`$pgm  t00-hello.c t00-hello.c t00-hello.c | tail -1 | awk '{print $1}'`
c=`wc -l t00-hello.c t00-hello.c t00-hello.c | tail -1 | awk '{print $1}'`
if [ "$c" != "$s" ]; then
    echo "*** Mismatch in count of newlines; $s != $c"
else
    echo "Matched newlines: $s = $c"
fi

exit 0
