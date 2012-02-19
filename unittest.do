exec >&2
TESTRUNNER=testrunner

dmd *.d -unittest  -I.. -of${TESTRUNNER}

./${TESTRUNNER}
