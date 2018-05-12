
FROM alpine
LABEL maintainer="Hidenori Sugiyama <madogiwa@gmail.com>"

## tini
RUN wget -O /tini https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64 && \
    chmod +x /tini

## install OpenJDK8 JRE
RUN \
  apk add --update --no-cache openjdk8-jre-base

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

## install ElasticMQ
ARG ELASTICMQ_VERSION=0.13.9

RUN \ 
  wget -O "/elasticmq-server.jar" "https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-${ELASTICMQ_VERSION}.jar" && \
  addgroup -g 1000 elasticmq && \
  adduser -G elasticmq -u 1000 -D elasticmq

ENTRYPOINT ["/tini", "--"]

USER elasticmq
CMD ["java", "-jar", "/elasticmq-server.jar"]

