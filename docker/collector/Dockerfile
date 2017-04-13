FROM cescoffier/vertx3-alpine

RUN apk add --update bash && apk add --update openssh && apk add --update curl && rm -rf /var/cache/apk/*
RUN apk update
RUN apk add ca-certificates
RUN apk add jq
RUN update-ca-certificates

RUN mkdir /usr/collector
ADD get-collector-artifact.sh /usr/collector/get-collector-artifact.sh
RUN sh /usr/collector/get-collector-artifact.sh
ADD config.json /usr/collector

ENV VERTICLE_PATH /usr/collector/io.weba.collector-fat.jar
ENV VERTICLE_NAME io.weba.collector.verticle.DeploymentVerticle
ENV VERTICLE_CONFIG /usr/collector/config.json

EXPOSE 80

ENTRYPOINT ["sh", "-c"]
CMD ["vertx run $VERTICLE_NAME -cp $VERTICLE_PATH -conf $VERTICLE_CONFIG"]