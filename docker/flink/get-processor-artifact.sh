#!/bin/bash

wget $(curl -s curl -s 'https://circleci.com/api/v1/project/webaio/processor/latest/artifacts?circle-token=b421a25b8b4486097155ebb25b1ace0e9031db11&branch=master&filter=successful' | jq -r '.[] | .url') -O /usr/local/flink/weba.jar
