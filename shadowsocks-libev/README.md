# Build shadowsocks-libev 3.x for RT-N16 from Ubuntu 16.04

## 1. Get docker container

```
docker pull mritd/asuswrt-merlin-build
```
## 2. Download toolchain

```
wget https://github.com/RMerl/asuswrt-merlin/archive/478.50.tar.gz
tar -zxf 478.50.tar.gz /data
```

## 3. Start container

```
docker run -dt --name build -v /data/asuswrt-merlin:/home/asuswrt-merlin mritd/asuswrt-merlin-build
```

## 4. Login docker and setup enviroment

```
docker exec -it build bash
export PATH=/opt/brcm/K26/hndtools-mipsel-uclibc-4.2.4/bin/:$PATH
```

## 5. Build dependency libraries

### 5.1 Build pcre

```
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz
tar -zxvf pcre-8.40.tar.gz
cd pcre-8.40
mkdir install
./configure --host=mipsel-linux-uclibc --prefix=`pwd`/install
cd ..
```

### 5.2 Build libmbedtls

```
wget https://tls.mbed.org/download/mbedtls-2.6.0-gpl.tgz
tar -zxvf mbedtls-2.6.0-gpl.tgz
cd mbedtls-2.6.0
mkdir install
export CC=mipsel-linux-uclibc-gcc
make install DESTDIR=`pwd`/install
cd ..
```

### 5.3 Build libsodium

```
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz
tar -zxvf libsodium-1.0.16.tar.gz
cd libsodium-1.0.16
mkdir install
./configure --prefix=`pwd`/install --host=mipsel-linux-uclibc
make
make install
cd ..
```

### 5.4 Build libcares

```
wget https://github.com/c-ares/c-ares/releases/download/cares-1_15_0/c-ares-1.15.0.tar.gz
tar -zxvf c-ares-1.15.0.tar.gz 
cd c-ares-1.15.0
mkdir install
./configure --prefix=`pwd`/install --host=mipsel-linux-uclibc
make
make install
cd ..
```

### 5.5 Build libev

```
git clone https://github.com/enki/libev.git
cd libev
mkdir install
./configure --prefix=`pwd`/install --host=mipsel-linux-uclibc
make
make install
cd ..
```

## 6. Fix issue of missing CAS built-in features in GCC 4.2.4

```
git clone https://github.com/bingzhenpan/asus_rt-n16.git
cd asus_rt-n16/shadowsocks/mips_cas_from_freebsd
./build.sh
cd ../../..
```
## 7. Finally, build shadowsocks-libev

### 7.1 Download source code and config
```
git clone --recursive https://github.com/shadowsocks/shadowsocks-libev.git
git checkout v3.2.3
cd shadowsocks-libev
./autogen.sh
mkdir install
./configure --disable-ssp --disable-documentation --host=mipsel-linux-uclibc --prefix=`pwd`/install --with-pcre=`pwd`/../pcre-8.40/install --with-mbedtls=`pwd`/../mbedtls-2.6.0/install --with-sodium=`pwd`/../libsodium-1.0.16/install --with-cares=`pwd`/../c-ares-1.15.0/install --with-ev=`pwd`/../libev/install LDFLAGS="`pwd`/../asus_rt-n16/shadowsocks/mips_cas_from_freebsd/stdatomic.o" CFLAGS="-Wno-uninitialized"
```

### 7.2 Disable TLS for libcork


```
vim libcork/include/libcork/config/gcc.h
```

change `#define CORK_CONFIG_HAVE_THREAD_STORAGE_CLASS  1` to `#define CORK_CONFIG_HAVE_THREAD_STORAGE_CLASS  0`

```
make
make install
```

Done!
