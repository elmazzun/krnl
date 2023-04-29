#!/bin/bash

# TODO make the image lab to NOT use root user while building the labs and
# compiling the krnl, this way I don't have to chown krnl and ./iso
sudo chown $USER:$USER krnl
sudo chown -R $USER:$USER ./iso/

nm krnl

# TODO This should be qemu-system-i686
qemu-system-i386 \
    -boot d \
    -S -s \
    -kernel krnl \
    -m 512
