#!/bin/bash


VERSION="6.4"
CONFIG=~/.config/zabbix/$VERSION

mkdir -p "$CONFIG"

rm -rf /tmp/$VERSION.zip
rm -rf /tmp/zabbix-release-$VERSION

# generate a SID by using:
# "Administration" => "General" => "API tokens"

# session token
SID=$(cat "$CONFIG/sid")

# api endpoint
JSONRPC=$(cat "$CONFIG/jsonrpc")

# download latest 6.4 branch
curl -kL "https://github.com/zabbix/zabbix/archive/refs/heads/release/$VERSION.zip" -o "/tmp/$VERSION.zip"

# unzip
cd /tmp
unzip "$VERSION.zip"

# go back to previous directory where PHP program is located
cd -

# import media types
echo "importing media types:"
find /tmp/zabbix-release-$VERSION/templates/media -type f -name '*.yaml' | \
while IFS= read -r MEDIA
do {
echo -n " $(basename -- "$MEDIA") "
php media_type.php $SID $JSONRPC $MEDIA | jq .result | grep "true" | tr '\n' '\0'
# if 'true' not received the print the template name
[[ $? -ne 0 ]] && echo $MEDIA
} done
echo
echo

echo "importing templates:"
# start template import
find /tmp/zabbix-release-$VERSION/templates -type f -name '*.yaml' | \
while IFS= read -r TEMPLATE
do {
echo -n " $(basename -- "$TEMPLATE") "
php delete_missing.php $SID $JSONRPC $TEMPLATE | jq .result | grep "true" | tr '\n' '\0'
echo " " | tr '\n' '\0'
# if 'true' not received the print the template name
[[ $? -ne 0 ]] && echo -e "\n$TEMPLATE\n"
} done

