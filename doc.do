. ./config.sh

DEPS=$(echo $SRCS |
sed -e 's/\.d/.html/g' |
sed -e 's/\.\.\///g')

redo-ifchange ${DEPS}
