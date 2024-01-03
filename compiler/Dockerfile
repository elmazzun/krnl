# LTS Ubuntu
FROM ubuntu:22.04

ARG USER_NAME=compiler
ARG USER_GROUP=compiler
ARG UID=1000
ARG GID=1000
ARG USER_HOME=/home/compiler

# This is where the tools will end up, install them locally only for "compiler"
# user; it is not recommended to globally install them
ENV PREFIX="${USER_HOME}/opt/cross"
# Prefix of the produced assemblies (for example i686-elf-gcc)
# This is the target platform which we will build against
ENV TARGET="i686-elf"
# Add the new installation to the PATH variable temporarily
# since it is required for the gcc build
ENV PATH="${PREFIX}/bin:$PATH"

# texinfo is required to build binutils
# GMP, MPC and MPFR are required to build GCC
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

# Compile binutils (assembler, disassembler, ...) runnable on my system but
# handling code in the format specified by $TARGET.
# --disable-nls: binutils won't include native language support, reducing
#                dependencies and compile time
# --with-sysroot: binutils won't enable sysroot support in the cross-compiler
#                 by pointing it to a default empty directory
RUN mkdir -p ${USER_HOME}/src/build-binutils
COPY binutils-2.41.tar.xz ${USER_HOME}/src
WORKDIR ${USER_HOME}/src
RUN tar -xf binutils-2.41.tar.xz
WORKDIR ${USER_HOME}/src/build-binutils
RUN ../binutils-2.41/configure --target=${TARGET} --prefix="${PREFIX}" \
    --with-sysroot --disable-nls --disable-werror && \
    make -j8 && make -j8 install

# Compile GCC and libgcc
# libgcc is a low-level support library which the compiler expects available at
# compile time.
# --disable-nls: is the same as for binutils above
# --without-headers: GCC won't rely on any C library (standard or runtime)
#                    being present for the target
# --enable-languages: GCC won't compile all the other language frontends it
#                     supports, but only C (and optionally C++)
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

# Use the new compiler by simply invoking $TARGET-gcc
RUN echo 'export PATH="$HOME/opt/cross/bin:$PATH"' >> ~/.bashrc

# WORKDIR /krnl-lab
# VOLUME /krnl-lab
# 
# CMD ["make"]
