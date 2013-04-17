. ./config.sh

redo-ifchange ${SRCS}

${DMD} -w ${SRCS} -I.. -lib -of$3
