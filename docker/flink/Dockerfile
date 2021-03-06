FROM java:openjdk-8-jre-alpine

RUN apk add --update bash && apk add --update openssh && apk add --update curl && rm -rf /var/cache/apk/*
RUN apk update
RUN apk add ca-certificates
RUN apk add openssl
RUN apk add snappy
RUN apk add jq
RUN update-ca-certificates

RUN mkdir /var/run/sshd
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/*
RUN echo 'root:secret' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

ENV JAVA_HOME /usr/lib/jvm/default-jvm

RUN mkdir ~/downloads
RUN cd ~/downloads && wget http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/flink/flink-1.2.0/flink-1.2.0-bin-hadoop27-scala_2.11.tgz
RUN tar zxvf ~/downloads/flink-1.2.0-bin-hadoop27-scala_2.11.tgz -C ~/downloads
RUN mv ~/downloads/flink-1.2.0 /usr/local/flink

ENV FLINK_HOME /usr/local/flink
ENV PATH $PATH:$FLINK_HOME/bin

ADD conf/flink-conf.yaml /usr/local/flink/conf/
ADD config-flink.sh /usr/local/flink/bin/
RUN chmod +x /usr/local/flink/bin/config-flink.sh
ADD get-processor-artifact.sh /usr/local/flink/get-processor-artifact.sh
RUN chmod +x /usr/local/flink/get-processor-artifact.sh

RUN mkdir /tmp/snappy

WORKDIR /usr/local/flink

RUN sh /usr/local/flink/get-processor-artifact.sh
