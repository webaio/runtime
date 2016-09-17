#!/usr/bin/env bash

curl -H 'Content-Type: application/json' -X PUT -d @../docker/elasticsearch/mapping/weba.json http://100.0.0.1:9200/weba_events