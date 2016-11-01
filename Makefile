
.PHONY: html push

all: html push

html:
	bash compile.sh

push:
	bash push.sh

