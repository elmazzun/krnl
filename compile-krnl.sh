#!/bin/bash

docker run \
    -it \
    --rm \
    -v=$(pwd):/krnl-lab \
    krnl-development-lab:0.1.0
