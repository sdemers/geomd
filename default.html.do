. ./config.sh

SRC=$2.d

redo-ifchange ${SRC}

${DMD} -c -o- -D ${INCL} ${SRC} -Df$3
