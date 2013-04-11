TESTRUNNER=testrunner

. ./config.sh

exec >&2

redo-always

${DMD} *.d -cov -unittest ${INCL} -of${TESTRUNNER}

./${TESTRUNNER}

cat *.lst | grep "% covered"
