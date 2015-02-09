#!/bin/bash

# set up the launcher environment and start the launcher in a new process
h="${TRAVIS_BUILD_DIR:-$PWD}"
d="${TEST_PATH:-$h/tmp}"
t="${TEST_COMMAND:-$h/test/test.sh}"

echo "Creating new test environment in ${d}"
rm -fr "$d"
mkdir -p "${d}/logs" "${d}/data" 2> /dev/null

cat > ${d}/config.json <<END
{
    "configuration": {
	"host": "localhost",
	"port": 8080,
	"endpoint": "vtk",
	"proxy_file": "${d}/proxy.txt",
	"sessionURL": "ws://${host}:${port}/ws",
	"timeout": 5,
	"log_dir": "${d}/logs",
	"upload_dir": "${d}/data",
	"fields": []
    },
    "sessionData": {"upDir": "/Home"},
    "resources": [
	{"host": "localhost", "port_range": [9001, 9005]}
    ],
    "properties": {
	"test_dir": "${d}",
	"log_dir": "${d}/logs",
	"data_dir": "${d}/data"
    },
    "apps": {
	"basic": {
	    "cmd": [
		"${t}", "basic"
	    ]
	}
    }
}
END

coverage run "${h}/launcher.py" "${d}/config.json" &> "${d}/server.log" < /dev/null &
pid=$(jobs -l %1 | awk '{print $2}')
echo $pid > "${d}/server.pid"
disown %1
echo "Server pid is \"$pid\""
if kill -0 $pid ; then
    echo "Success"
    exit 0
else
    echo "Failed"
    cat "${d}/server.log"
    exit 1
fi
