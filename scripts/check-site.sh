#!/bin/bash

# check if server responds on a given port

hostip=$(/sbin/ip route|awk '/default/ { print $3 }')
interval=2
tout=60
port=$1

for (( i=0; i<$tout; i+=$interval ))
do 
  resp=$(curl -s -I $hostip:$port | grep "HTTP/1.1")
  if [[ $resp == *"200"* ]]
  then
    echo "$resp"
    exit 0
  fi
  echo "waiting... $(( $i + $interval ))s"
  sleep $interval
done

echo "$resp"
echo "Site unavailable at http://$hostip:$port"
exit 62
