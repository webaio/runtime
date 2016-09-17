#!/usr/bin/env bash

sudo rm -rf ../docker/elasticsearch/data
sudo rm -rf ../docker/elasticsearch/log
sudo rm -rf ../docker/postgres/data
sudo rm -rf ../docker/zookeeper/data

mkdir ../docker/elasticsearch/data
mkdir ../docker/elasticsearch/log
mkdir ../docker/postgres/data
mkdir ../docker/zookeeper/data