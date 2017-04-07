#!/bin/sh
. ./config.sh

INDEX=$1
if [ -z "$INDEX" ]
  then
   echo "Please provide an index"
   exit
fi

REPLICAS=$2
if [ -z "$REPLICAS" ]
  then
   echo "Please provide a host name"
   exit
fi

echo "Setting index $INDEX to $REPLICAS"
curl -XPUT "$ELASTIC_HOST/$INDEX/_settings" -d "{"index" : {\"number_of_replicas\" : ${REPLICAS}}}"
