# Docker Images

1. Syncthing
2. Plex
3. Transmission
4. GitLab
5. HomeAssistant
6. Traefik

## Structure 

| Internal Only Tools | External Tools       | 
| :---                | :---                 |
| Syncthing           | Plex                 |
|                     | Transmission         |
|                     | GitLab               |
|                     | HomeAssistant        |

Since all external tools will be routed through duckDNS, 
Traefik will handle the reverse proxying to allow easy access to 
all of the different web services.

As Syncthing is only being run as an internal service, I will keep
it as a single docker command.  All of the other services will be 
built as a docker-compose.yml file.  This is because they are all
interdependent for the user facing functions.  It also provides a 
slight degree of separation from Syncthing and the others.  
