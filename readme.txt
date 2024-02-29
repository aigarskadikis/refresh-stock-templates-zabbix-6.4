1) On your frontend server download:

upload.php
refresh_stock.sh

2) Set bash script executable:

chmod +x refresh_stock.sh 
3) In GUI, under "Administration" => "General" => "API tokens", create an API token, assign that to user which is Zabbix Super Admin.

4) Launch the program. Set 2 arguments - Zabbix API tokens and endpoint of JSON RPC

./refresh_stock.sh 133c784408ab0e83e0ecc56816851d4281b19098be52b11ee95df5ec1fcc34d7 http://127.0.0.1/api_jsonrpc.php
This will download the latest archive (https://github.com/zabbix/zabbix/tree/release/6.4) of templates and re-import them all.

