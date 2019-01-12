#! /bin/bash

mipsel-linux-uclibc-gcc -D__SYNC_ATOMICS -march=mips32 -c stdatomic.c
