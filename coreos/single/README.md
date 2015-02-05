# Sandbox of [CoreOS](https://github.com/coreos)

## Setup Virtual Machines
```
$ vagrant up
```

## Check IP addresses of hosts
|interface|description       |
|:--------|:-----------------|
|lo       |loopback          |
|enp0s3   |bridge of vagrant |
|enp0s8   |host address      |
|docker0  |bridge of docker  |

###  host1
- ens0s3: 192.168.33.11/24
- docker0: 172.17.42.1/16

```
core@host1 ~ $ ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:b3:5a:f5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 85789sec preferred_lft 85789sec
    inet6 fe80::a00:27ff:feb3:5af5/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:6d:87:ce brd ff:ff:ff:ff:ff:ff
    inet 192.168.33.11/24 brd 192.168.33.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe6d:87ce/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
    inet 172.17.42.1/16 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::5484:7aff:fefe:9799/64 scope link
       valid_lft forever preferred_lft forever
```

## Run containers and check interfaces
### Run containers
```
core@host1 ~ $ docker run -i -d ubuntu /bin/bash
8820609961db1b52ac310f513a6a76f810d5922223d168e78715f7ead6f80464
core@host1 ~ $ docker run -i -d ubuntu /bin/bash
62d48fe9602ce1a546fcffc043abd20d5398d929de3f279e1434164dd8555d1b
core@host1 ~ $ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
62d48fe9602c        ubuntu:14.04        "/bin/bash"         About a minute ago   Up About a minute                       sharp_mccarthy
8820609961db        ubuntu:14.04        "/bin/bash"         11 minutes ago       Up 11 minutes                           boring_kowalevski
```

### Check Host interfaces
Added
- vethbddd670
- veth4d7be40

```
core@host1 ~ $ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:b3:5a:f5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 85505sec preferred_lft 85505sec
    inet6 fe80::a00:27ff:feb3:5af5/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:6d:87:ce brd ff:ff:ff:ff:ff:ff
    inet 192.168.33.11/24 brd 192.168.33.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe6d:87ce/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
    link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
    inet 172.17.42.1/16 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::5484:7aff:fefe:9799/64 scope link
       valid_lft forever preferred_lft forever
10: vethbddd670: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master docker0 state UP qlen 1000
    link/ether 42:8c:78:a9:d5:bb brd ff:ff:ff:ff:ff:ff
    inet6 fe80::408c:78ff:fea9:d5bb/64 scope link
       valid_lft forever preferred_lft forever
12: veth4d7be40: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master docker0 state UP qlen 1000
    link/ether ea:c6:ad:06:0d:ef brd ff:ff:ff:ff:ff:ff
    inet6 fe80::e8c6:adff:fe06:def/64 scope link
       valid_lft forever preferred_lft forever
```

`docker0` connected to interfaces of each containers
```
core@host1 ~ $ brctl show
bridge name  bridge id          STP enabled  interfaces
docker0      8000.56847afe9799  no           veth4d7be40
                                             vethbddd670
```

### Check Containter interfaces
```

core@host1 ~ $ docker exec -i 62d ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
11: eth0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 02:42:ac:11:00:05 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.5/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:5/64 scope link
       valid_lft forever preferred_lft forever

core@host1 ~ $ docker exec -i 882 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
9: eth0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 02:42:ac:11:00:04 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.4/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:4/64 scope link
       valid_lft forever preferred_lft forever
```

## Connect a container to container by --link
Use `--link` option, register `TINYWEB_HOST`, `TINYWEB_PORT` and more to env.
And register `172.17.0.5	tinyweb` to `/etc/hosts`.
```
core@host1 ~ $ docker run -d --name tinyweb foostan/tinyweb
a7368f3958b501eec3373b600fa0c12341c038afbb5b83c41274f2d40c34ec3d

core@host1 ~ $ docker run --rm -i -t --link tinyweb:tinyweb ubuntu /bin/bash
root@8e407ae5a350:/# env | grep TINYWEB
TINYWEB_PORT_80_TCP_PORT=80
TINYWEB_PORT_80_TCP_PROTO=tcp
TINYWEB_NAME=/kickass_thompson/tinyweb
TINYWEB_PORT=tcp://172.17.0.5:80
TINYWEB_PORT_80_TCP=tcp://172.17.0.5:80
TINYWEB_PORT_80_TCP_ADDR=172.17.0.5
root@8e407ae5a350:/# cat /etc/hosts
172.17.0.16	8e407ae5a350
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.5	tinyweb
root@8e407ae5a350:/# ping tinyweb
PING tinyweb (172.17.0.5) 56(84) bytes of data.
64 bytes from tinyweb (172.17.0.5): icmp_seq=1 ttl=64 time=0.071 ms
64 bytes from tinyweb (172.17.0.5): icmp_seq=2 ttl=64 time=0.071 ms
^C
--- tinyweb ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.071/0.071/0.071/0.000 ms
root@8e407ae5a350:/# exit
exit
```
