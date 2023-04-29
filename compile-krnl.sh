#!/bin/bash

docker run \
    -it \
    --rm \
    -v=$(pwd):/krnl-lab \
    --cpus="2" \
    --memory=2g \
    krnl-development-lab:0.1.0
