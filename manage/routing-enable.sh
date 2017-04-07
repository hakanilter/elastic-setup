#!/bin/sh
. ./config.sh

echo "Enabling shard routing..."
curl -XPUT "${ELASTIC_HOST}/_cluster/settings" -d '
{
    "transient" : {
        "cluster.routing.allocation.enable" : "all"
    }
}
'
