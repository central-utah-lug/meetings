FROM docker.io/python:alpine
LABEL MAINTAINER=heywoodlh

RUN pip3 install ansible

RUN apk add --no-cache bash vim nano openssh git doctl \
    && apk add --no-cache edit --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN mkdir /ansible-demo

COPY . /ansible-demo

WORKDIR /ansible-demo

ENTRYPOINT ["bash"]
