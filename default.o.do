. ./SOURCES.sh

SRC=$2.d

redo-ifchange ${SRC}

dmd -w -wi -c ${INCL} ${SRC} -of$3
