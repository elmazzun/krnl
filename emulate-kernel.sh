#!/bin/bash

qemu-system-i386 \
    -boot d \
    -kernel kernel \
    -m 512
