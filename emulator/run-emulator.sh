#!/bin/bash

# --device=/dev/kvm: by adding this flag, you are not required to use 
#                    --privileged
docker run \
    -it \
    --rm \
    --device=/dev/kvm \
    krnl-emulator:0.1.0 sh

# # TODO make the image lab to NOT use root user while building the labs and
# # compiling the krnl, this way I don't have to chown krnl and ./iso
# sudo chown $USER:$USER krnl
# sudo chown -R $USER:$USER ./iso/

# echo "Listing symbol names in object krnl file..."
# nm krnl

# # TODO This should be qemu-system-i686
# qemu-system-i386 \
#     -boot d \
#     -kernel krnl \
#     -m 512

    # -S -s \