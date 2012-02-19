. ./SOURCES.sh

DEPS=$(echo $SRCS |
sed -e 's/\.d/.o/g' |
sed -e 's/\.\.\///g')

redo-ifchange ${DEPS}

dmd ${DEPS} -lib -of$3
