#!/bin/bash

[[ -d /data/clamav ]] || mkdir -p /data/clamav
[[ -d /tmp ]] || mkdir -p /tmp

echo "[+] Configure and update ClamAV cvd"
cvd config set --dbdir /data/clamav
cvd update > /dev/null

echo "[+] Extract files from ClamAV cvd files"
cd /tmp || exit
7z x /data/clamav/daily.cvd > /dev/null
7z x /data/clamav/main.cvd > /dev/null
tar xf daily
tar xf main

echo "[+] Extract md5 sums from ClamAV databases"
[[ -f /data/output/ClamAV-md5 ]] && rm -f /data/output/ClamAV-md5*
awk -F: '{print $1}' main.hdb >> /data/output/ClamAV-md5
awk -F: '{print $1}' main.hsb >> /data/output/ClamAV-md5
awk -F: '{print $1}' daily.hdb >> /data/output/ClamAV-md5
awk -F: '{print $1}' daily.hsb >> /data/output/ClamAV-md5

echo "[+] Create index files from ClamAV databases for Autopsy"
cd /data/output || exit
hfind -i md5sum ClamAV-md5 > /dev/null
