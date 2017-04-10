
.PHONY: html lab push

all: html lab

html:
	bash compile.sh

lab:
	rsync -av --exclude=.git . lab1:~/scratch/ness17

push:
	bash push.sh

get_abstracts:
	rsync -av --exclude=posters lab1:~/bak/ness/2017-04-10/ abstract-booklet/bak/

