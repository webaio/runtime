[![Build Status](https://travis-ci.org/webaio/runtime.svg?branch=master)](https://travis-ci.org/webaio/runtime)

First run application

1. `docker-compose stop && docker-compose build && docker-compose up -d`
2. Check status `docker-compose ps`
3. `docker exec -it memsql memsql-shell`
4. `create database webaio;`
5. `use webaio`
6. Copy migrations:

        create table session (
          id VARCHAR(40) NOT NULL,
          visitorId VARCHAR(40) NOT NULL,
          startAt TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
          endAt TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
          primary key (id)
        );
        
        create table event_session (
          id VARCHAR(40) NOT NULL,
          eventId VARCHAR(40) NOT NULL,
          sessionId VARCHAR(40) NOT NULL,
          visitorId VARCHAR(40) NOT NULL,
          visitAt TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
          eventType VARCHAR(20) NOT NULL,
          payload JSON NOT NULL,
          device JSON NOT NULL,
          localization JSON NOT NULL,
          dates JSON NOT NULL,
          primary key (id)
        );
        
        create table event_aggregator (
          id VARCHAR(40) NOT NULL,
          sessionId VARCHAR(40) NOT NULL,
          visitorId VARCHAR(40) NOT NULL,
          numberOfActions INTEGER NOT NULL,
          primary key (id)
        );
        
7. Exit from memsql container
8. Go to http://IP-ADDRESS:9000/ and create cluster `weba` with zookeper address `zookeeper:2181`
9. `docker exec -it jobmanager /bin/bash`
10. `cd /usr/local/flink/bin/`
11. `./flink run /app.jar`
12. Check status of services

        MEMSQL: http://IP-ADDRESS:9001/status
        KAFKA : http://IP-ADDRESS:9000/clusters/weba/topics 
        FLINK: http://IP-ADDRESS:48080/#/overview 
        
13. Run on `locust/` command `locust --no-web -c 1 -r 1 --only-summary --host=http://IP-ADDRESS/` to test infrastructure
  