#!/bin/bash

# check if server responds on a given url

url=$1
interval=2
tout=60

for (( i=0; i<$tout; i+=$interval ))
do 
  resp=$(curl -s -I $url | grep "HTTP/1.1")
  if [[ $resp == *"200"* ]]
  then
    echo "$resp"
    exit 0
  fi
  echo "waiting... $(( $i + $interval ))s"
  sleep $interval
done

echo "$resp"
echo "Site unavailable at http://$url"
exit 62
