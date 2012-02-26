. ./config.sh

DEPS=$(echo $SRCS | sed -e 's/\.d/.html/g')

redo-ifchange ${DEPS}
