FROM alpine:3.17

WORKDIR /krnl-lab

VOLUME /krnl-lab

RUN apk update && apk add binutils \
    gcc \
    grub \
    make \
    nasm \
    xorriso

COPY . .

CMD ["make"]
