# LTS Ubuntu
FROM ubuntu:22.04

ARG USER_NAME=compiler
ARG USER_GROUP=compiler
ARG UID=1000
ARG GID=1000
ARG USER_HOME=/home/compiler

# This is where the tools will end up; install them locally only
# for "compiler" user (recommended)
ENV PREFIX="${USER_HOME}/opt/cross"
# Prefix of the produced assemblies (for example i686-elf-gcc)
ENV TARGET="i686-elf"
# Add the new installation to the PATH variable temporarily
# since it is required for the gcc build
ENV PATH="${PREFIX}/bin:$PATH"

# Install required software
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends \
        sudo \
        wget \
        xz-utils \
        build-essential \
        gcc \
        g++ \
        vim \
        gawk \
        bison \
        make \
        flex \
        nasm \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        texinfo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create "compiler" group, add "compiler" user and
# add "compiler" user to sudoers
RUN groupadd -g ${GID} ${USER_GROUP} && \
    useradd ${USER_NAME} -u ${UID} -g ${USER_GROUP} -s /bin/bash -m && \
    usermod -aG sudo ${USER_NAME}

# User "compiler" will now cross-compile binutils and GCC
USER ${UID}:${GID}

# COPY . .

# Compatibility matrix of successful builds for GCC cross-compiler:
# https://wiki.osdev.org/Cross-Compiler_Successful_Builds
# I will use GCC 13.2.0 and binutils 2.41

# Building cross-compiler as described in https://wiki.osdev.org/GCC_Cross_Compiler

# Compile binutils
RUN mkdir -p ${USER_HOME}/src/build-binutils
COPY binutils-2.41.tar.xz ${USER_HOME}/src
WORKDIR ${USER_HOME}/src
RUN tar -xf binutils-2.41.tar.xz
WORKDIR ${USER_HOME}/src/build-binutils
RUN ../binutils-2.41/configure --target=${TARGET} --prefix="${PREFIX}" \
    --with-sysroot --disable-nls --disable-werror && \
    make -j8 && make -j8 install

# Compile GCC
RUN mkdir -p ${USER_HOME}/src/build-gcc
COPY gcc-13.2.0.tar.xz ${USER_HOME}/src
WORKDIR ${USER_HOME}/src
RUN tar -xf gcc-13.2.0.tar.xz
RUN which -- ${TARGET}-as || echo ${TARGET}-as is not in the PATH
WORKDIR ${USER_HOME}/src/build-gcc
RUN ../gcc-13.2.0/configure --target=${TARGET} --prefix="${PREFIX}" \
        --disable-nls --enable-languages=c,c++ --without-headers && \
    make -j8 all-gcc && \
    make -j8 all-target-libgcc && \
    make -j8 install-gcc && \
    make -j8 install-target-libgcc

# WORKDIR /krnl-lab
# VOLUME /krnl-lab
# 
# CMD ["make"]
