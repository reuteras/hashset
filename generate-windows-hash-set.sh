#!/bin/bash

function usage() {
    echo "$0"
    exit
}

CURRENT_NAME="VanillaWindowsReference"
EMPTY="d41d8cd98f00b204e9800998ecf8427e"
OUTPUT="$(pwd)/output"

if [[ "$#" -ne "0" ]]; then
    usage
fi

if ! which hfind > /dev/null ; then
    echo "sleuthkit is not installed. Install with:"
    echo "Linux: sudo apt install -y sleuthkit"
    echo "macOS with brew: brew install sleuthkit"
    exit
fi

# Clean
function cleanup() {
    rm -f "${CONF}/apt-mirror-${CURRENT_NAME}-run.list"
}

trap cleanup EXIT
cleanup

echo "[+] Create hash set from VanillaWindowsReference."

if [[ -d "${CURRENT_NAME}" ]]; then
    cd "${CURRENT_NAME}" || exit
    echo "[+] Old checkout of VanillaWindowsReference exits - get updates"
    git pull > /dev/null 2>&1
    cd .. || exit
fi

if [[ ! -d "${CURRENT_NAME}" ]]; then
    echo "[+] Clone VanillaWindowsReference repository"
    git clone https://github.com/AndrewRathbun/VanillaWindowsReference > /dev/null 2>&1
fi

[[ ! -d "${OUTPUT}" ]] && mkdir -p "${OUTPUT}"

find VanillaWindowsReference -type f -name "*.csv" -exec cat {} \; | \
    grep -vE 'C:\\(test\.csv|PsExec_IgnoreThisFile_ResearchTool\.exe)' | \
    cut -d, -f3,9 | tr -d '"' | tr ',' ' ' | \
    grep -E " [a-fA-F0-9]{32}$" | \
    grep -vi "${EMPTY}" | \
    sed -E "s/(.+) ([a-fA-F0-9]{32})$/\2 \1/" | \
    sort | uniq > "${OUTPUT}/${CURRENT_NAME}-md5"

rm -f "${OUTPUT}/${CURRENT_NAME}-md5"*idx*
hfind -i md5sum "${OUTPUT}/${CURRENT_NAME}-md5"
