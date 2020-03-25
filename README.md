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
