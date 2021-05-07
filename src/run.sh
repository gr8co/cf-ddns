#!/bin/bash
# 
# This bash script relies on environment variable being set with Cloudflare's
# DNS API token and the hostname to update with this host's public IP.
#
# Super simple, you can run it as it is or use the docker container.
#
# Relies on being able to access external domain to see the actual public IP address.
# 
# Dependent on jq and curl
#
# HOST='home.myhost.com'
# ZONE='Cloudflare_ZONE'
# TOKEN='MYCloudflareAPIToken'

if [[ ! -v HOST ]]; then
    echo "HOST is not set" && exit 1
fi

if [[ ! -v ZONE ]]; then
    echo "ZONE is not set" && exit 1
fi

if [[ ! -v TOKEN ]]; then
    echo "TOKEN is not set" && exit 1
fi

IP=`curl -s https://api.ipify.org`
if [ $? -eq 0 ]; then
    echo "Your IP is $IP"
else
    echo "Unable to get ip from api.ipify.org"
    exit 1
fi

# Get HOST ID
HOST_ID=`curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records?type=A&name=$HOST" \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" | jq -r '.result[0].id'`
if [ $? -eq 0 ]; then
    echo "Your Host ID is $HOST_ID"
else
    echo "Unable to get host id of $HOST"
    exit 1
fi

# Update IP
RESULT=`curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$HOST_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      --data '{"type":"A","name":"'$HOST'","content":"'$IP'","ttl":120,"proxied":false}' | jq -r '.success'`
if [ $? -eq 0 ]; then
    if [ $RESULT == 'true' ]; then
        echo "$HOST A record successfully updated to $IP"
    else
        echo "Unable to update $HOST A record"
    fi
else
    echo "Unable to post update to Cloudflare API"
    exit 1
fi
