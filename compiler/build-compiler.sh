#!/bin/bash

docker build \
    --memory=10g \
    -t krnl-compiler:0.1.0 .
