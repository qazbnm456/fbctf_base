FROM phusion/baseimage:latest
MAINTAINER Lobsiinvok lobsiinvok@tdohacker.org

ENV HOME /root

ADD lib.sh $HOME/lib.sh 
ADD dependencies.sh $HOME/dependencies.sh
RUN apt-get update \
  && apt-get install -y rsync
RUN $HOME/dependencies.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*