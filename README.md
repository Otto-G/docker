# Home Server

**Operating System:** Debian 10 "Buster"

**Hardware:**

- [InWin IW-MS04 ITX Case](https://www.amazon.com/gp/product/B0167NCADS)
- [AsRock J3710](https://www.amazon.com/gp/product/B01E97ZTPA)
- [8GB Crucial Ram x 2](https://www.amazon.com/gp/product/B006YG8X9Y) for a total of 16gb of ram
- [Sandisk 240GB SSD](https://www.amazon.com/gp/product/B01F9G43WU) as boot drive
- [HGST Ultrastar 7k4000 3TB x 2](https://www.amazon.com/gp/product/B01LYVD7ME) as storage drives in ZPool Mirror
- [Seagate Ironwolf 4TB x 1](https://smile.amazon.com/gp/product/B07H289S79/) as another storage drive since one HGST 
  drive was throwing some errors
- [Aeotec z-wave adapter](https://www.amazon.com/gp/product/B00X0AWA6E) for controlling my zwave home automation network
- [Intel PRO/1000 Pt Network adapter](https://www.amazon.com/gp/product/B000BMZHX2/)
  - !! Note, x4 PCI slot where motherboard only has x1.  I modified motherboard to fit card, don't really recommend. 
    Still better than Realtek though.  


**Major Programs:**

* [Cockpit](https://github.com/cockpit-project/cockpit)
    * Web based server admin page
* [Cockpit-zfs-manager](https://github.com/optimans/cockpit-zfs-manager)
    * Plug-in for Cockpit that allows managing of ZFS pools
* [Traefik](https://github.com/containous/traefik)
    * Reverse proxy
* [Docker](https://www.docker.com/)
    * Container system to hold different systems.  Part of the main way that the system is organized.  
    

**Installed programs:**

    sudo aptitude install docker lm-sensors hddtemp unp curl apache2-utils samba cockpit-docker smartmontools wakeonlan
    sudo aptitude install -t buster-backports cockpit dkms spl-dkms zfs-dkms zfsutils-linux
    
## ZFS Issues

When attaching/dealing with ZFS drives.  It is best to use the GUID since the path that is actually attached to the pool
is not going to be the normal part of the drive, but rather one of the partitions.  It's possible to get the GUID by 
running `sudo zdb`.  The output will have something similar to what's below and will show the guid along with the
actual path that zfs is using as the drive path.  

```shell
$ sudo zdb

type: 'disk'
id: 1
guid: 11376827263620761442
path: '/dev/disk/by-id/wwn-0x5000cca22cc0a9e3-part2'
whole_disk: 1
DTL: 160
create_txg: 4
com.delphix:vdev_zap_leaf: 152

```
    
## DuckDNS

It is possible to reduce the load on DuckDNS by using the below script to only send an update when your ip address
 actually changes.  

    IP_ADDRESS=$(curl "http://checkip.amazonaws.com" | head -1) &&  # No space is a requirement to set the variable
      [ $IP_ADDRESS = "$(cat "ipaddr.txt")" ] ||  # Compare the returned ip address with the old ipaddress only proceed if no match  
      curl "https://www.duckdns.org/update?domains=$MYADDR&token=$MYTOKEN&ip" &&  # Send the update to duckdns  
      echo $IP_ADDRESS > ipaddr.txt  # Store the new ipaddress in the file  

- _Make sure to replace $MYADDR, and $MYTOKEN with the address prefix and token from duckDNS or set them as variables_

## Docker Images

1. [Syncthing](https://github.com/linuxserver/docker-syncthing)
    * Syncthing [main page](https://syncthing.net/)
    * File syncing between devices
2. [Plex](https://github.com/plexinc/pms-docker)
    * Home media server
3. [Transmission](https://github.com/linuxserver/docker-transmission)
4. [GitLab](https://docs.gitlab.com/omnibus/docker/)
5. [Home Assistant](https://www.home-assistant.io/docs/installation/docker/)
    * Config is saved [here](https://github.com/Otto-G/HomeAutomation/blob/master/configuration.yaml)
6. [Traefik](https://docs.traefik.io/getting-started/install-traefik/#use-the-official-docker-image)
7. [Calibre](https://github.com/linuxserver/docker-calibre-web)

### Structure 

| Internal Only Tools | External Tools       | 
| :---                | :---                 |
| Syncthing           | Plex                 |
|                     | Transmission         |
|                     | GitLab               |
|                     | HomeAssistant        |
|                     | Calibre              |

Since all external tools will be routed through duckDNS, 
Traefik will handle the reverse proxying to allow easy access to 
all of the different web services.  One thing to keep in mind is that 
all of the tools that are going to be running together under Traefik 
need to be in bridge mode so that they work properly.  There might be 
a way around that issue, but I couldn't find it.  

Running Syncthing as part of the docker compose file helps when it comes
time to perform an update since I can just run `docker-compose pull` and
`docker-compose up -d` to update and bring up all of the updated services.  
Since this is so much easier I'll keep everything together.  Syncthing 
will still be kept un-managed by traefik since there is no need to be able 
to work with it remotely.  