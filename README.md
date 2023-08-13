# krnl

Creating a k(e)rn(e)l for fun.

## Building the krnl

I use [Docker](https://www.docker.com/) to create the krnl build environment 
image where I cross-compile the krnl.

## Testing the krnl

I use [QEMU](https://www.qemu.org/) to run the krnl on a i686 architecture and 
[GDB](https://www.sourceware.org/gdb/) to troubleshoot it.

## Workflow

Assuming this is the first time you work with this project.

```bash
# Clone this repo
$ git clone ... && cd krnl

# Install Docker, QEMU and GDB
$ sudo apt install ...

# Copy .my-gdbinit in your home and rename it ./gdbinit

# Build the krnl build environment Docker image
$ ./build-lab.sh
[+] Building 17.1s (9/9) FINISHED                                                             
 => [internal] load build definition from Dockerfile                   0.0s
 ...
 => => naming to docker.io/library/krnl-development-lab:0.1.0          0.0s

# Compile the krnl
$ ./compile-krnl.sh                       

# Test the krnl
$ ./emulate-krnl.sh
```

The Docker image will mount this current directory as a volume: this way, if 
you want to edit the krnl sources, you don't have to re-build the Docker image 
in order to copy updated sources in lab Docker image; all you have to do is:

- edit krnl sources;
- `./compile-krnl.sh && ./emulate-krnl.sh`

## Debugging

We will troubleshoot our krnl with GDB.

In `emulate-krnl.sh`, QEMU is started with `-s -S` command line switches:

- `-S`: do not start CPU at startup

- `-s`: shorthand for -gdb tcp::1234, i.e. open a gdbserver on TCP port 1234

Our custom .gdbinit, `.my-gdbinit`, has the commands that connects GDB to QEMU.

After running the emulated krnl with `emulate-krnl.sh`, copy the commands in 
`.my-gdbinit` in your `.gdbinit`; open another shell and just type `gdb`: 
you should see:

```
$  gdb -q  
0x00100018 in _start ()
(gdb) info functions
All defined functions:

File krnl.c:
61:	int main(void);
52:	void print_string(char *, unsigned char);
40:	void term_init();
36:	uint16_t vga_entry(unsigned char, uint8_t);

Non-debugging symbols:
0x0010000c  _start
(gdb) 
```

## Resources and credits

- https://www.linuxjournal.com/content/what-does-it-take-make-kernel-0
- http://www.osdever.net/bkerndev/Docs/title.htm
- https://wiki.osdev.org/Main_Page
