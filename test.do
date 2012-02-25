TESTRUNNER=testrunner

. ./config.sh

exec >&2

redo-ifchange *.d

${DMD} *.d -unittest ${INCL} -of${TESTRUNNER}

./${TESTRUNNER}
