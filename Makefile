VERSION=0.2.1

all: swc asdoc test-build

swc:
	compc -load-config+=test/Runner-config.xml -include-sources=src -output=bin/dungdungdung-v$(VERSION).swc
asdoc:
	asdoc -load-config+=test/Runner-config.xml -doc-sources=src -output=docs
test-build:
	mxmlc test/Runner.mxml	
test: test-build
	open bin/index.html

clean:
	-rm -fr docs/*
	-rm bin/dungdungdung*
	-rm bin/testsuite*