#!/bin/bash

. secret.sh
lftp -e "mirror -Rv html /edu.uconn.stat/public_html; quit;" sftp://ness.stat.uconn.edu:22 -u $LFTP_USER,$LFTP_PASSWORD

