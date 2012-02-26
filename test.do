TESTRUNNER=testrunner

. ./config.sh

exec >&2

DEPS=$(echo $SRCS | sed -e 's/\.d/.o/g')
redo-ifchange ${DEPS}

${DMD} *.d -cov -unittest ${INCL} -of${TESTRUNNER}

./${TESTRUNNER}

cat *.lst | grep "% covered"
