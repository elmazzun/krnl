#!/bin/bash

docker run \
    -it \
    --rm \
    -v=$(pwd):/krnl-lab \
    --cpus="2" \
    --memory=4g \
    krnl-development-lab:0.1.0
