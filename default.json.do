. ./config.sh

SRC=$2.d

redo-ifchange ${SRC}

${DMD} -c ${INCL} ${SRC} -X -Xf$3
