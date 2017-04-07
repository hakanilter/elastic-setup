#!/bin/sh
export ELASTIC_HOST=http://localhost:9200

if [ -z "$ELASTIC_HOST" ]
  then
   echo "Please provide a host name"
   exit
fi
