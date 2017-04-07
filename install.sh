#!/bin/sh

# config
ES_VERSION=2.4.4
INSTALLATION_DIR=/home/hakanilter/dev/

TEMP_DIR=/tmp

# cluster config
CLUSTER_NAME=YOUR_CLUSTER_NAME
HOST=$(hostname)
if [ -z "$ALL_HOSTS" ]
  then
    ALL_HOSTS="[\"host1\", \"host2\", \"$HOST\"]"
fi

# install elastic
wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz -P $TEMP_DIR/
tar xvf $TEMP_DIR/elasticsearch-$ES_VERSION.tar.gz 
mv elasticsearch-$ES_VERSION $INSTALLATION_DIR/
ln -s $INSTALLATION_DIR/elasticsearch-$ES_VERSION $INSTALLATION_DIR/elastic

# create config file
cat elasticsearch.yml.template \
    | sed -e "s/\$CLUSTER_NAME/${CLUSTER_NAME}/g" \
    | sed -e "s/\$HOST/${HOST}/g" \
    | sed -e "s/\$ALL_HOSTS/${ALL_HOSTS}/g" > elasticsearch.yml
mv elasticsearch.yml $INSTALLATION_DIR/elastic/config/

# install plugins
cd $INSTALLATION_DIR/elastic
bin/plugin install karmi/elasticsearch-paramedic/2.0
bin/plugin install lmenezes/elasticsearch-kopf/2.x
bin/plugin install license
bin/plugin install -b marvel-agent

echo "completed..."
