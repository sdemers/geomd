. ./config.sh

DEPS=$(echo $SRCS | sed -e 's/\.d/.json/g')

redo-ifchange ${DEPS}

