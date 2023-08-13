FROM alpine:3.17

# This is where the tools will end up
ENV PREFIX="$HOME/opt/cross"

# Prefix of the produced assemblies (for example i686-elf-gcc)
ENV TARGET=i686-elf

# Add the new installation to the PATH variable temporarily
# since it is required for the gcc build
ENV PATH="$PREFIX/bin:$PATH"

ENV USER="lab-builder"
ENV GROUP="lab-builder-group"

# binutils
RUN apk update && apk add grub \
    gawk \
    make \
    gcc \
    g++ \
    musl-dev gmp-dev mpc1-dev mpfr-dev \
    gcompat \
    texinfo \
    nasm \
    xorriso

COPY . .

# Compile binutils and GCC for i686
RUN mkdir -p $PREFIX && mkdir -p $HOME/src && cd $HOME/src && \
    mkdir build-binutils build-gcc && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.xz && \
    tar -xf binutils-2.40.tar.xz && \
    cd build-binutils && \
    ../binutils-2.40/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror && \
    make && make install && \
    cd $HOME/src && which -- $TARGET-as && \
    wget https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz && \
    tar -xf gcc-13.1.0.tar.xz && \
    cd build-gcc && \
    ../gcc-13.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers && \
    make all-gcc && make all-target-libgcc && \
    make install-gcc && make install-target-libgcc

WORKDIR /krnl-lab
VOLUME /krnl-lab

CMD ["make"]
