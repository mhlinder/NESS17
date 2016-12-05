#!/bin/bash

for fn in `\ls md` ; do
    b=${fn%.*}
    if [ "$b" == "abstract_form" ]; then
        pandoc --template template.html -T "NESS 2017" --smart \
               -f markdown+link_attributes+header_attributes \
               -H html/abstractdata/header.php \
               -t html -o html/$b.html md/$fn
    else
        pandoc --template template.html -T "NESS 2017" --smart \
               -f markdown+link_attributes+header_attributes \
               -t html -o html/$b.html md/$fn
    fi
done

for fn in `\ls html | \grep 'reg.*.html'` ; do
    b=${fn%.*}
    mv html/$b.html html/$b.php
done

mv html/abstract_form.html html/abstract_form.php

