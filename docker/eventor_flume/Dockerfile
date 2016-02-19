FROM debian:jessie

RUN apt-get update && apt-get install -q -y --no-install-recommends wget unzip bc

RUN mkdir /opt/java
RUN wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" -qO- \
  http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz \
  | tar zxvf - -C /opt/java --strip 1

RUN mkdir /opt/flume
RUN wget -qO- http://archive.apache.org/dist/flume/1.6.0/apache-flume-1.6.0-bin.tar.gz \
  | tar zxvf - -C /opt/flume --strip 1

ADD start-flume.sh /opt/flume/bin/start-flume
ADD flume.conf /opt/flume/conf/

ENV JAVA_HOME /opt/java
ENV PATH /opt/flume/bin:/opt/java/bin:$PATH

COPY lib flume-libs
RUN mkdir /opt/flume/plugins.d/
RUN cp -rf /flume-libs/* /opt/flume/plugins.d

CMD [ "sh" , "/opt/flume/bin/start-flume" ]