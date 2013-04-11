. ./config.sh

redo-ifchange ${SRCS}

${DMD} ${SRCS} -I.. -lib -of$3
