#!/bin/bash

# --device=/dev/kvm: by adding this flag, you are not required to use 
#                    --privileged

readonly KVM_GID=$(cat /etc/group | grep kvm | cut -d: -f3)

docker run -it --rm \
    --device=/dev/kvm \
    --group-add $KVM_GID \
    krnl-emulator:0.1.0 bash

# Run the following command inside the krnl-emulator in order to test QEMU
# with KVM enabled
# dd if=/dev/zero of=test.img bs=1M count=1 && timeout 30s qemu-system-i386 -nographic -enable-kvm -hda test.img

# qemu-system-i386 \
#     -boot d \
#      -S -s \
#     -kernel krnl \
#     -m 512