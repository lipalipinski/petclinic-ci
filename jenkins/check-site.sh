#!/bin/bash

step=2
tout=60
port=80

for (( i=0; i<$tout; i+=$step ))
do 
  resp=$(curl -s -I localhost:$port | grep "HTTP/1.1")
  if [[ $resp == *"200"* ]]
  then
    echo "$resp"
    exit 0
  fi
  echo "waiting... $(( $i + $step ))s"
  sleep $step
done

echo "$resp"
echo "Site unavailable at http://localhost:$port"
exit 62
