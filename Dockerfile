FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y wget curl vim make git
RUN apt install -y python3-venv
RUN wget  https://bootstrap.pypa.io/get-pip.py
RUN python3 -m venv /ksldocsenv
ENV PATH=/ksldocsenv/bin:$PATH
RUN python3 get-pip.py
COPY docs/requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt
WORKDIR /workdir
