#!/bin/bash

# remove old dir. start fresh
sudo rm -rf /tmp/6.4.zip

sudo rm -rf /tmp/zabbix-release-6.4

# download latest 6.4 branch
curl -kL https://github.com/zabbix/zabbix/archive/refs/heads/release/6.4.zip -o /tmp/6.4.zip

# unzip
cd /tmp
unzip 6.4.zip

# go back to previous directory where PHP program is located
cd -

# start template import
find /tmp/zabbix-release-6.4/templates -type f -name '*.yaml' | \
while IFS= read -r TEMPLATE
do {
php upload.php $1 $2 $TEMPLATE
} done
