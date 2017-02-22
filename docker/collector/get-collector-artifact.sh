#!/bin/bash

wget $(curl -s curl -s 'https://circleci.com/api/v1/project/webaio/collector/latest/artifacts?circle-token=5a6e8add38d9bc18d5f065f59cf2063d49e08a27&branch=master&filter=successful' | jq -r '.[] | .url') -O /usr/collector/io.weba.collector-fat.jar
