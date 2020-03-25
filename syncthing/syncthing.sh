docker create \
 --name=syncthing \
 -e PUID=1000 \
 -e PGID=1000 \
 -e TZ=America/New_York
 -e UMASK_SET=022 \
 -p 8384:8384 \
 -p 22000:22000 \
 -p 21027:21027/udp \
 -v :data \
 --restart unless-stopped \
 linuxserver/syncthing
