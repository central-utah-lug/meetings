#!/usr/bin/env bash

docker buildx ls | grep -q multiarch || docker buildx create --name multiarch --driver docker-container --use

docker buildx build --push --tag docker.io/heywoodlh/ansible-demo:latest --platform linux/amd64,linux/arm64 --file Dockerfile .
