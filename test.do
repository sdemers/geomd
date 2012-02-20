exec >&2
TESTRUNNER=testrunner

redo-ifchange *.d

dmd *.d -unittest -I.. -of${TESTRUNNER}

./${TESTRUNNER}
