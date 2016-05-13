FROM phusion/baseimage:latest
MAINTAINER Lobsiinvok lobsiinvok@tdohacker.org

ENV HOME /root

COPY lib.sh $HOME/lib.sh 
COPY dependencies.sh $HOME/dependencies.sh
RUN apt-get update \
  && apt-get install -y rsync \
  && $HOME/dependencies.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
