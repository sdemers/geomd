# sources are all .d files except the testrunner

SRCS=$(ls *.d | sed -e 's|testrunner.d||g')
