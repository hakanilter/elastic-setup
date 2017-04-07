#!/bin/sh

# config -- modify them
ES_VERSION=2.4.4
INSTALLATION_DIR=/opt
CLUSTER_NAME=$1
ALL_HOST=
export REGION="eu-west-1"
export TAG="customElasticSearch"

# other configs
TEMP_DIR=/tmp
HOST=$(hostname)

# check config
if [ -z "$ALL_HOSTS" ]
  then
    # get host names from aws tags
    ALL_HOSTS=$(config/aws-hosts.sh)
fi
if [ -z "$ALL_HOSTS" ]
  then
    echo "Please provide hostnames, example:"
    echo "ALL_HOST=\"host1\", \"host2\""
    exit
fi
if [ -z "$CLUSTER_NAME" ]
  then
    echo "Please provide a cluster name, example:"
    echo "./setup.sh <CLUSTER_NAME>"
    exit
fi

# install elastic
wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.tar.gz -P $TEMP_DIR/
tar xvf $TEMP_DIR/elasticsearch-$ES_VERSION.tar.gz 
mv elasticsearch-$ES_VERSION $INSTALLATION_DIR/
ln -s $INSTALLATION_DIR/elasticsearch-$ES_VERSION $INSTALLATION_DIR/elastic

# update config 
cat config/elasticsearch.yml.template \
    | sed -e "s/\$CLUSTER_NAME/${CLUSTER_NAME}/g" \
    | sed -e "s/\$HOST/${HOST}/g" \
    | sed -e "s/\$ALL_HOSTS/${ALL_HOSTS}/g" > elasticsearch.yml
mv elasticsearch.yml $INSTALLATION_DIR/elastic/config/

# copy scripts
cp config/start.sh $INSTALLATION_DIR/elastic/
cp config/elastic /etc/init.d/

# install plugins
cd $INSTALLATION_DIR/elastic
bin/plugin install karmi/elasticsearch-paramedic/2.0
bin/plugin install lmenezes/elasticsearch-kopf/2.x
bin/plugin install license
bin/plugin install -b marvel-agent

# create user
useradd elastic 
chown -R elastic:elastic $INSTALLATION_DIR/elasticsearch-$ES_VERSION

# install sysstat
yum install -y sysstat

echo "completed..."
