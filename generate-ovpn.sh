#!/usr/bin/env bash -e

ovpn_file="mwaa.ovpn"
aws=$(which aws)
vpn_endpoint_id=$(terraform output -raw vpn_endpoint_id)

$aws ec2 export-client-vpn-client-configuration \
  --client-vpn-endpoint-id "$vpn_endpoint_id" \
  --output text > $ovpn_file

crt=$(cat mwaa-vpn-client-dev.crt)
echo -e "\n<cert>\n$crt\n</cert>" >> $ovpn_file

key=$(cat mwaa-vpn-client-dev.key)
echo -e "\n<key>\n$key\n</key>\n" >> $ovpn_file
