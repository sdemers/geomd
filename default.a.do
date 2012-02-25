. ./config.sh

DEPS=$(echo $SRCS |
sed -e 's/\.d/.o/g' |
sed -e 's/\.\.\///g')

redo-ifchange ${DEPS}

${DMD} ${DEPS} -lib -of$3
