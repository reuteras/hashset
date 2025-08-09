#!/bin/bash

[[ -d /data/clamav ]] || mkdir -p /data/clamav
[[ -d /tmp ]] || mkdir -p /tmp

echo "[+] Update apt and install tools"
DEBIAN_FRONTEND=noninteractive apt -qqq update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt -qqqy install file git p7zip-full pipx sleuthkit > /dev/null 2>&1
pipx ensurepath > /dev/null 2>&1
source /root/.bashrc
pipx install uv > /dev/null 2>&1
uv tool install cvdupdate > /dev/null 2>&1

cd /data || exit
echo "[+] Run script for ClamAV"
./clamav.sh

cd /data || exit
echo "[+] Run script for Windows"
./generate-windows-hash-set.sh

echo "[+] Done"
