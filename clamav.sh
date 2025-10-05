#!/bin/bash

EMPTY="d41d8cd98f00b204e9800998ecf8427e"

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
{
    awk -F: '{print $1}' main.hdb | grep -v "$EMPTY"
    awk -F: '{print $1}' main.hsb | grep -v "$EMPTY"
    awk -F: '{print $1}' daily.hdb | grep -v "$EMPTY"
    awk -F: '{print $1}' daily.hsb | grep -v "$EMPTY"
} >> /data/output/ClamAV-md5

echo "[+] Create index files from ClamAV databases for Autopsy"
cd /data/output || exit
hfind -i md5sum ClamAV-md5 > /dev/null
