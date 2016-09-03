#!/usr/bin/env bash

docker exec -it jobmanager ./bin/flink run -d -p 2 \
-c io.weba.processor.flink.job.IngestEventsElasticsearchJob weba.jar \
--kafka-bootstrap-servers ns381473.ip-94-23-248.eu:9092 --kafka-group-id IngestEventsElasticsearchJob \
--kafka-topic eventor_webserver \
--es-index webaio_events \
--es-type webaio_events \
--es-servers ns381473.ip-94-23-248.eu:9300 \
--es-cluster-name webaio \
-Dorg.xerial.snappy.tempdir=/tmp/snappy