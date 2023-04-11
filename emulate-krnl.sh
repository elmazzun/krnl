#!/bin/bash

qemu-system-i386 \
    -boot d \
    -kernel krnl \
    -m 512
