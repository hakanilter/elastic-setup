#!/bin/sh

TMP_FILE=/tmp/ec2Info

ec2-describe-instances --region $REGION --filter "instance-state-name=running" --filter "tag-value=$TAG" > $TMP_FILE
instances=`cat $TMP_FILE | grep INSTANCE | awk {'print $4'}`

hosts=""
for instance in $instances; do
  if [ -z "$hosts" ]
    then
      hosts="\"$instance\""
    else
      hosts="$hosts,\"$instance\""
  fi
done

echo $hosts