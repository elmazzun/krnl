#!/bin/bash

docker run \
    -it \
    --rm \
    -v=$(pwd):/kernel-lab \
    kernel-development-lab:0.1.0 \
    "$1" # This may be /bin/bash
