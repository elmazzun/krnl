FROM alpine:3.17

WORKDIR /kernel-lab

VOLUME /kernel-lab

RUN apk update && apk add binutils \
    gcc \
    grub \
    make \
    nasm

COPY . .

CMD ["./build-kernel.sh"]
