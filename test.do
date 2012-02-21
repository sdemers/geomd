TESTRUNNER=testrunner

. ./SOURCES.sh

exec >&2

redo-ifchange *.d

dmd *.d -unittest ${INCL} -of${TESTRUNNER}

./${TESTRUNNER}
