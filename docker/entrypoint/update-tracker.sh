#!/bin/bash

wget $(curl -s 'https://circleci.com/api/v1/project/webaio/tracker/latest/artifacts?circle-token=66892b7cef43e0dfdb44063b56b190e2cb4b2786&branch=master&filter=successful' | jq -r '.[] | select(.url | contains("index.min.js")) | .url') -O /usr/share/nginx/html/index.min.js
