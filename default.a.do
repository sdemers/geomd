. ./config.sh

DEPS=$(echo $SRCS | sed -e 's/\.d/.o/g')

redo-ifchange ${DEPS}

${DMD} ${DEPS} -lib -of$3
