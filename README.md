# Elastic Setup

Installation scripts for Elastic Search 2.x

## AWS EC2 Setup

Following script helps setting up an ElasticSearch on EC2 instance:

```
#!/bin/bash
sudo yum update -y
wget https://github.com/hakanilter/elastic-setup/archive/master.zip
unzip master.zip
cd elastic-setup-master/setup
sudo ./setup.sh cluster01
sudo service elastic start
```
