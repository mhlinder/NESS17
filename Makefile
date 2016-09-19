html:
	pandoc --template template.html -T "NESS 2017" --smart -o index.html index.md
	pandoc --template template.html -T "NESS 2017" --smart -o keynote-speakers.html keynote-speakers.md
	pandoc --template template.html -T "NESS 2017" --smart -o program.html program.md
	pandoc --template template.html -T "NESS 2017" --smart -o committees.html committees.md
	pandoc --template template.html -T "NESS 2017" --smart -o short-courses.html short-courses.md
	pandoc --template template.html -T "NESS 2017" --smart registration.md | sed "s/1234321/<?php include('regform.php'); ?>/" > registration.php
	pandoc --template template.html -T "NESS 2017" --smart -o call-for-papers.html call-for-papers.md
	pandoc --template template.html -T "NESS 2017" --smart -o abstracts.html abstracts.md
	pandoc --template template.html -T "NESS 2017" --smart -o travel-accommodations.html travel-accommodations.md
	pandoc --template template.html -T "NESS 2017" --smart -o contact.html contact.md
	cp index.html keynote-speakers.html program.html committees.html short-courses.html registration.php call-for-papers.html abstracts.html travel-accommodations.html contact.html custom.css regform.php web/
