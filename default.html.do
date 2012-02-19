SRC=$2.d

redo-ifchange ${SRC}

dmd -c -D -I.. ${SRC} -Df$3
