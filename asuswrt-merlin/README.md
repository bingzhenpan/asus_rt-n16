# Build asuswrt-merlin firmware for RT-N16 from Ubuntu 16.04

## 1. Get docker container

```
docker pull mritd/asuswrt-merlin-build
```

## 2. Download merlin source code

```
wget https://github.com/RMerl/asuswrt-merlin/archive/478.50.tar.gz
tar -zxf 478.50.tar.gz /data
```

## 3. Start container

```
docker run -dt --name build -v /data/asuswrt-merlin:/home/asuswrt-merlin mritd/asuswrt-merlin-build
```

## 4. Setup enviroment

```
export PATH=/opt/brcm/K26/hndtools-mipsel-uclibc-4.2.4/bin/:$PATH
```

## 5. Build

```
cd ~/asuswrt-merlin/release/src-rt
make clean
make rt-n16
```

Done! You can get the new firmware in `image/RT-N16_3.0.0.4_378.50_0.trx`
