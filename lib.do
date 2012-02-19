SRCS=$(find . -maxdepth 1 -name "*.d")

DEPS=$(echo $SRCS |
sed -e 's/\.d/.o/g' |
sed -e 's/\.\.\///g')

redo-ifchange ${DEPS}

dmd 
