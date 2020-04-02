# Home Server

**Operating System:** Debian 10 "Buster"

**Hardware:**

- [InWin IW-MS04 ITX Case](https://www.amazon.com/gp/product/B0167NCADS/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)
- [AsRock J3710](https://www.amazon.com/gp/product/B01E97ZTPA/ref=oh_aui_search_asin_title?ie=UTF8&psc=1)
- [8GB Crucial Ram x 2](https://www.amazon.com/gp/product/B006YG8X9Y/ref=ppx_od_dt_b_asin_title_s00?ie=UTF8&psc=1)
  for a total of 16gb of ram
- [Sandisk 240GB SSD](https://www.amazon.com/gp/product/B01F9G43WU) as boot drive
- [HGST Ultrastar 7k4000 3TB x 2](https://www.amazon.com/gp/product/B01LYVD7ME/ref=ppx_od_dt_b_asin_title_s00?ie=UTF8&psc=1)
  as storage drives in ZPool Mirror
- [Aeotec z-wave adapter](https://www.amazon.com/gp/product/B00X0AWA6E/ref=oh_aui_search_asin_title?ie=UTF8&psc=1)
  for controlling my zwave home automation network
- [Intel PRO/1000 Pt Network adapter](https://www.amazon.com/gp/product/B000BMZHX2/ref=oh_aui_search_asin_title?ie=UTF8&psc=1)
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

    sudo aptitude install docker lm-sensors hddtemp unp curl apache2-utils samba cockpit-docker
    sudo aptitude install -t buster-backports cockpit dkms spl-dkms zfs-dkms zfsutils-linux
    
    
## DuckDNS

It is possible to reduce the load on DuckDNS by using the below script to only send an update when your ip address
 actually changes.  

    IP_ADDRESS=$(curl "http://checkip.amazonaws.com" | head -1) &&  # No space is a requirement to set the variable
      [ $IP_ADDRESS = "$(cat "ipaddr.txt")" ] ||  # Compare the returned ip address with the old ipaddress only proceed if no match  
      curl "https://www.duckdns.org/update?domains=$MYADDR&token=$MYTOKEN&ip" &&  # Send the update to duckdns  
      echo $IP_ADDRESS > ipaddr.txt  # Store the new ipaddress in the file  

- _Make sure to replace $MYADDR, and $MYTOKEN with the address prefix and token from duckDNS or set them as variables_

## Docker Images

1. [Syncthing](https://syncthing.net/)
    * File syncing between devices
2. [Plex](https://github.com/plexinc/pms-docker)
    * Home media server
3. Transmission
4. GitLab
5. [Home Assistant](https://www.home-assistant.io/docs/installation/docker/)
    * Config is saved [here](https://github.com/Otto-G/HomeAutomation/blob/master/configuration.yaml)
6. Traefik
7. Calibre

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

As Syncthing is only being run as an internal service, I will keep
it as a single docker command.  All of the other services will be 
built as a docker-compose.yml file.  This is because they are all
interdependent for the user facing functions.  It also provides a 
slight degree of separation from Syncthing and the others.  
