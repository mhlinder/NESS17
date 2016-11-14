#!/bin/bash

for fn in `\ls md/` ; do
    b=${fn%.*}
    pandoc --template template.html -T "NESS 2017" --smart -o html/$b.html md/$fn ;
done

for fn in `\ls html | \grep 'reg.*.html'` ; do
    b=${fn%.*}
    echo $b
    mv html/$b.html html/$b.php
done
