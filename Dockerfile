FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y wget curl vim 
RUN apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa
 #   apt install -y python3.9 && \
  #  apt install -y python-is-python3
