. ./SOURCES.sh

SRC=$2.d

redo-ifchange ${SRC}

dmd -c -o- -D ${INCL} ${SRC} -Df$3
