#!/usr/bin/env bash

docker exec -it weba_flink_jobmanager ./bin/flink run -d -p 1 \
-c io.weba.processor.flink.job.IngestEventsElasticsearchJob weba.jar \
--kafka-bootstrap-servers 100.0.0.1:9092 --kafka-group-id IngestEventsElasticsearchJob \
--kafka-topic weba_events \
--es-index weba_events \
--es-type weba_events \
--es-servers 100.0.0.1:9300 \
--es-cluster-name weba \
-Dorg.xerial.snappy.tempdir=/tmp/snappy