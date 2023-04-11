# krnl

This is a personal experiment in building a krnl to learn more about computer hardware.

This krnl lacks practically everything, it will never be finished (let's be  
realistic, come on) and it is already a miracle that it passes compilation;  
therefore, I named it krnl without the vowels because it is definitely  
missing something.

Doesn't that make sense? Then make your own krnl with its own vowels.

## Building the krnl

I use [Docker](https://www.docker.com/) to create the krnl build environment image.

Run the `compile-krnl.sh` script to create the `krnl-development-lab` image.

## Testing the krnl

I use [QEMU](https://www.qemu.org/) to test the compiled krnl.

Run the `emulate-krnl.sh` script to create the `krnl-development-lab` image.

## Workflow

Assuming this is the first time you work with this project.

```bash
# Clone this repo
$ git clone ... && cd krnl

# Install Docker and QEMU
$ sudo apt install ...

# Build the krnl build environment Docker image
$ ./compile-krnl.sh
[+] Building 17.1s (9/9) FINISHED                                                             
 => [internal] load build definition from Dockerfile                   0.0s
 ...
 => => naming to docker.io/library/krnl-development-lab:0.1.0          0.0s

# Compile the krnl
$ ./run-lab.sh                       
Compiling bootloader...
nasm -f elf32 boot.asm -o boot.o
Compiling krnl...
...
Make has completed.

# Test the krnl
$ ./emulate-krnl.sh
```

The Docker image will mount this current directory as a volume: this way,  
if you want to edit the krnl sources, you don't have to re-build the Docker  
image in order to copy updated sources in lab Docker image; all you have  
to do is:

- edit krnl sources;
- `./run-lab.sh && ./emulate-kernel.sh`