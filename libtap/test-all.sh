#!/bin/sh -x
set -e
set -u
MYDIR=$(dirname $0)
prove "$@" --exec $MYDIR/test-one.sh tests/*.out
