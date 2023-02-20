FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y wget curl vim make git
RUN apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt install -y python3.9 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.9 2 && \
    apt-get install -y python3.9-distutils && wget  https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py
COPY docs/requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt
WORKDIR /workdir
