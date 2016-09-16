#!/usr/bin/env bash

docker exec -it jobmanager ./bin/flink run -d -p 2 \
-c io.weba.processor.flink.job.IngestEventsElasticsearchJob weba.jar \
--kafka-bootstrap-servers weba_kafka:9092 --kafka-group-id IngestEventsElasticsearchJob \
--kafka-topic weba_entrypoint \
--es-index weba_events \
--es-type weba_events \
--es-servers weba_elasticsearch:9300 \
--es-cluster-name weba \
-Dorg.xerial.snappy.tempdir=/tmp/snappy