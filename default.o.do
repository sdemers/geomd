SRC=$2.d

redo-ifchange ${SRC}

dmd -w -wi -c -I.. ${SRC} -of$3
