html:
	pandoc --template template.html -T "NESS 2017" \
		--smart -o index.html index.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o keynote-speakers.html keynote-speakers.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o program.html program.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o committees.html committees.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o short-courses.html short-courses.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o call-for-participation.html call-for-participation.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o abstracts.html abstracts.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o travel-accommodations.html travel-accommodations.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o contact.html contact.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o registration.php -t html registration.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o regsend.php -t html regsend.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o regconf.php -t html regconf.md
	pandoc --template template.html -T "NESS 2017" \
		--smart -o 404.html 404.md
	cp index.html keynote-speakers.html program.html \
		committees.html short-courses.html registration.php \
		call-for-participation.html abstracts.html \
		travel-accommodations.html contact.html custom.css \
		normalize.css skeleton.css regform.php regsend.php \
		regreview.php regconf.php regemail.php ness17.png \
		404.html web/
