
.PHONY: html push

all: html

html:
	bash compile.sh

push:
	lftp -e "mirror -Rv html /edu.uconn.stat/public_html; quit;" sftp://mhl14002@ness.stat.uconn.edu:22

