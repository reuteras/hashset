#!/bin/bash

[[ -d /data/clamav ]] || mkdir -p /data/clamav
[[ -d /data/tmp ]] || mkdir -p /data/tmp

echo "[+] Update apt and install tools"
DEBIAN_FRONTEND=noninteractive apt -qqq update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt -qqqy install file p7zip-full pipx sleuthkit > /dev/null 2>&1
pipx ensurepath > /dev/null 2>&1
source /root/.bashrc
pipx install uv > /dev/null 2>&1
uv tool install cvdupdate > /dev/null 2>&1

echo "[+] Configure and update cvd"
cvd config set --dbdir /data/clamav
cvd update > /dev/null

echo "[+] Extract files from cvd files"
cd /data/tmp || exit
7z x ../clamav/daily.cvd > /dev/null
7z x ../clamav/main.cvd > /dev/null
tar xf daily
tar xf main

echo "[+] Extract md5 sums from ClamAV databases"
[[ -f /data/clamav_md5.txt ]] && rm -f /data/clamav_md5.txt*
awk -F: '{print $1}' main.hdb >> /data/clamav_md5.txt
awk -F: '{print $1}' main.hsb >> /data/clamav_md5.txt
awk -F: '{print $1}' daily.hdb >> /data/clamav_md5.txt
awk -F: '{print $1}' daily.hsb >> /data/clamav_md5.txt

echo "[+] Create index files for Autopsy"
cd /data || exit
hfind -i md5sum clamav_md5.txt > /dev/null

echo "[+] Done"
