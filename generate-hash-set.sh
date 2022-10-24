#!/bin/bash

function usage() {
    echo "$0 <dist> <dist version>"
    echo "Possible versions for dist:"
    echo "ubuntu"
    echo ""
    echo "Possible <dist version> values for ubuntu:"
    echo "1804"
    echo "2004"
    echo "2204"
    exit
}

CURRENT_OS="${1}"
CURRENT_VERSION="${2}"
MIRROR="$(pwd)/mirror/${CURRENT_OS}"
OUTPUT="$(pwd)/output"
CURRENT_NAME="${CURRENT_OS}_${CURRENT_VERSION}"
CONF="$(pwd)/apt-mirror-conf"
# md5 for empty file
EMPTY="d41d8cd98f00b204e9800998ecf8427e"

if [[ "$#" -ne "2" ]]; then
    usage
fi

if [[ ! -e "${CONF}/apt-mirror-${CURRENT_NAME}.list" ]]; then
    echo "No configuration available for ${CURRENT_OS} ${CURRENT_VERSION}"
    usage
fi

if ! dpkg --list | grep apt-mirror > /dev/null ; then
    echo "apt-mirror is not installed. Install with:"
    echo "sudo apt install -y apt-mirror"
    exit
fi

if ! dpkg --list | grep sleuthkit > /dev/null ; then
    echo "sleuthkit is not installed. Install with:"
    echo "sudo apt install -y sleuthkit"
    exit
fi

# Clean
function cleanup() {
    rm -f "${CONF}/apt-mirror-${CURRENT_NAME}-run.list" \
        "${OUTPUT}/${CURRENT_NAME}-md5.new" \
        "${OUTPUT}/${CURRENT_NAME}-md5.tmp"
}

trap cleanup EXIT
cleanup

# Create ${CURRENT_NAME}-done if first time. Only get md5 from files newer then this file
[[ ! -f "${MIRROR}/${CURRENT_NAME}-done" ]] && touch --date "2000-01-01" "${MIRROR}/${CURRENT_NAME}-done" && sleep 1

echo ""
echo "####################################################"
echo "Mirror Ubuntu Linux."
echo "####################################################"
echo ""

[[ ! -d "${MIRROR}/data" ]] && mkdir -p "${MIRROR}/data"
[[ ! -d "${OUTPUT}" ]] && mkdir -p "${OUTPUT}"

cat "${CONF}/apt-mirror-${CURRENT_NAME}.list" | sed -e "s#/var/spool/apt-mirror#${MIRROR}/data#" > "${CONF}/apt-mirror-${CURRENT_NAME}-run.list"
apt-mirror "${CONF}/apt-mirror-${CURRENT_NAME}-run.list"

IFS=$'\n'
for package in $(find "${MIRROR}" -name '*.deb' -newer "${MIRROR}/${CURRENT_NAME}-done" ); do
    dpkg-deb --ctrl-tarfile "${package}" | tar Oxf  - ./md5sums >> "${OUTPUT}/${CURRENT_NAME}-md5.new" 2> /dev/null
done
unset IFS

# Exit if no new md5
[[ ! -e "${OUTPUT}/${CURRENT_NAME}-md5.new" ]] && exit

if [[ ! -e "${OUTPUT}/${CURRENT_NAME}-md5" ]]; then
    grep -v "${EMPTY}" "${OUTPUT}/${CURRENT_NAME}-md5.new" | sort -u > "${OUTPUT}/${CURRENT_NAME}-md5"
else
    sort -u "${OUTPUT}/${CURRENT_NAME}-md5.new" "${OUTPUT}/${CURRENT_NAME}-md5" | grep -v "${EMPTY}" > "${OUTPUT}/${CURRENT_NAME}-md5.tmp"
    mv "${OUTPUT}/${CURRENT_NAME}-md5.tmp" "${OUTPUT}/${CURRENT_NAME}-md5"
fi

rm -f "${OUTPUT}/${CURRENT_NAME}-md5"*idx*
hfind -i md5sum "${OUTPUT}/${CURRENT_NAME}-md5"

touch "${MIRROR}/${CURRENT_NAME}-done"
