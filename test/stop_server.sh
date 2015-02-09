#!/bin/bash
h="${TRAVIS_BUILD_DIR:-$PWD}"
d="${TEST_PATH:-$h/tmp}"

fail=0
echo "Stopping test environment in ${d}"
if [ -f ${d}/server.pid ] ; then
    pid=$(cat ${d}/server.pid)
    kill -15 $pid
else
    echo "Could not find pid file at ${d}/server.pid"
    fail=1
fi
rm -fr "$d"

exit $fail
