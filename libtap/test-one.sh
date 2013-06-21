#!/bin/bash
set -e
set -u

# We use TAP, the Test Anything Protocol

BASE_PATH=${1%.*}

SOURCEDIR=../src
if [ -d "$SOURCEDIR" ]; then
    OPTIONS="-I $SOURCEDIR -M $SOURCEDIR"
fi

# TAP: plan
echo 1..1

TEST_PROG=$BASE_PATH.rb
if [ ! -f $TEST_PROG ]; then
    TEST_PROG=$BASE_PATH.ycp
fi
if [ ! -f $TEST_PROG ]; then
    # TAP: not ok
    echo "not ok 1 $BASE_PATH # Cannot find test prog for $1"
    exit 0
fi

TEST_OUT=$BASE_PATH.out
TEST_ERR=$BASE_PATH.err

TMPOUT=tmp.out.${BASE_PATH##*/}
TMPERR=tmp.err.${BASE_PATH##*/}

run/runtest.sh $OPTIONS $TEST_PROG $TMPOUT $TMPERR

if ! diff -u $TEST_ERR $TMPERR; then
    # TAP: not ok
    echo "not ok 1 $BASE_PATH # stderr mismatch"
    exit 0
fi
if ! diff -u $TEST_OUT $TMPOUT; then
    # TAP: not ok
    echo "not ok 1 $BASE_PATH # stdout mismatch"
    exit 0
fi

# TAP: ok
echo ok 1 $BASE_PATH
