#!/bin/bash


docker pull marpteam/marp-cli
docker run --rm -it \
    --name marp \
    -p 8080:8080 -p 37717:37717 \
    -v $PWD/:/home/marp/app/ \
    -e LANG=$LANG \
    -e MARP_USER="$(id -u):$(id -g)" \
    marpteam/marp-cli \
        --html --allow-local-files -s .