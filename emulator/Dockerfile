# LTS Ubuntu
FROM ubuntu:22.04

ARG USER_NAME=emulator
ARG USER_GROUP=emulator
ARG UID=1000
ARG GID=1000
ARG USER_HOME=/home/emulator

# Install KVM, QEMU and OVMF (UEFI)
# RUN apt update \
#     && apt install add \
#         qemu \
#         qemu-img \
#         open-vm-tools \
#         qemu-system-i386 \
#         qemu-system-x86_64 \
#         ovmf

# https://www.qemu.org/download/#linux
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends \
        qemu-system \
        qemu-kvm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create "emulator" group, add "emulator" user and
# add "emulator" user to sudoers
RUN groupadd -g ${GID} ${USER_GROUP} && \
    useradd ${USER_NAME} -u ${UID} -g ${USER_GROUP} -s /bin/bash -m && \
    usermod -aG sudo ${USER_NAME}

USER ${UID}:${GID}

# WORKDIR /
# COPY krnl /

# ENTRYPOINT qemu-system-i386 -h

# ENTRYPOINT qemu-system-i386 \
#     -boot d \
#     -kernel krnl \
#     -m 512 \
#     --enable-kvm \
#     -nographic

    # -append 'root=/dev/vda console=ttyS0' \
    # -enable-kvm \
    # -bios /usr/share/ovmf/bios.bin \

