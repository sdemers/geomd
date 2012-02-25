. ./config.sh

SRC=$2.d

redo-ifchange ${SRC}

${DMD} -w -wi -c ${INCL} ${SRC} -of$3
