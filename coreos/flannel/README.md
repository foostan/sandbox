# Sandbox of [flannel](https://github.com/coreos/flannel) on [CoreOS](https://github.com/coreos)

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
|flannel0 |bridge of flannel |
|docker0  |bridge of docker  |

###  host1
- ens0s3: 192.168.33.11/24
- flannel0: 10.0.70.0/16
- docker0: 10.0.70.1/24

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
       valid_lft 84753sec preferred_lft 84753sec
    inet6 fe80::a00:27ff:feb3:5af5/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:16:f5:68 brd ff:ff:ff:ff:ff:ff
    inet 192.168.33.11/24 brd 192.168.33.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe16:f568/64 scope link
       valid_lft forever preferred_lft forever
5: flannel0: <POINTOPOINT,UP,LOWER_UP> mtu 1472 qdisc pfifo_fast state UNKNOWN qlen 500
    link/none
    inet 10.0.70.0/16 scope global flannel0
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1472 qdisc noqueue state DOWN
    link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
    inet 10.0.70.1/24 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::5484:7aff:fefe:9799/64 scope link
       valid_lft forever preferred_lft forever
```

###  host2
- ens0s3: 192.168.33.12/24
- flannel0: 10.0.30.0/16
- docker0: 10.0.30.1/24

```
core@host2 ~ $ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:b3:5a:f5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 84963sec preferred_lft 84963sec
    inet6 fe80::a00:27ff:feb3:5af5/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:c2:72:db brd ff:ff:ff:ff:ff:ff
    inet 192.168.33.12/24 brd 192.168.33.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fec2:72db/64 scope link
       valid_lft forever preferred_lft forever
5: flannel0: <POINTOPOINT,UP,LOWER_UP> mtu 1472 qdisc pfifo_fast state UNKNOWN qlen 500
    link/none
    inet 10.0.30.0/16 scope global flannel0
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN
    link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
    inet 10.0.30.1/24 scope global docker0
       valid_lft forever preferred_lft forever
```

## Check IP addresses of containers
### container on host1
- eth0: 10.0.70.4/24
```
core@host1 ~ $ docker run -it --rm ubuntu /bin/bash
root@18720cc3a0b7:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
11: eth0: <BROADCAST,UP,LOWER_UP> mtu 1472 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 02:42:0a:00:46:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.70.4/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:aff:fe00:4604/64 scope link
       valid_lft forever preferred_lft forever
```

### container on host2
- eth0: 10.0.30.2/24
```
core@host2 ~ $ docker run -it --rm ubuntu /bin/bash
root@1144d9459d10:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
7: eth0: <BROADCAST,UP,LOWER_UP> mtu 1472 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 02:42:0a:00:02:02 brd ff:ff:ff:ff:ff:ff
    inet 10.0.30.2/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:aff:fe00:202/64 scope link
       valid_lft forever preferred_lft forever
```

## Ping to containers on other hosts
### host1 to host2
```
root@18720cc3a0b7:/# ping 10.0.30.2
PING 10.0.30.2 (10.0.30.2) 56(84) bytes of data.
64 bytes from 10.0.30.2: icmp_seq=1 ttl=61 time=0.739 ms
64 bytes from 10.0.30.2: icmp_seq=2 ttl=61 time=0.513 ms
64 bytes from 10.0.30.2: icmp_seq=3 ttl=61 time=0.316 ms
```

### host2 to host1
```
root@18720cc3a0b7:/# ping 10.0.70.4
PING 10.0.70.4 (10.0.70.4) 56(84) bytes of data.
64 bytes from 10.0.70.4: icmp_seq=1 ttl=61 time=0.739 ms
64 bytes from 10.0.70.4: icmp_seq=2 ttl=61 time=0.513 ms
64 bytes from 10.0.70.4: icmp_seq=3 ttl=61 time=0.316 ms
```

## Check etcd
```

core@host1 ~ $ etcdctl ls --recursive
/coreos.com
/coreos.com/network
/coreos.com/network/config
/coreos.com/network/subnets
/coreos.com/network/subnets/10.0.70.0-24
/coreos.com/network/subnets/10.0.30.0-24
/coreos.com/updateengine
/coreos.com/updateengine/rebootlock
/coreos.com/updateengine/rebootlock/semaphore

core@host1 ~ $ etcdctl get /coreos.com/network/config
{"Network":"10.0.0.0/16"}

core@host1 ~ $ etcdctl get /coreos.com/network/subnets/10.0.70.0-24
{"PublicIP":"192.168.33.11"}

core@host1 ~ $ etcdctl get /coreos.com/network/subnets/10.0.30.0-24
{"PublicIP":"192.168.33.12"}
```
