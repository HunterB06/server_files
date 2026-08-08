# Env file

You should add a .env at the root of the repository (same level as compose.yml)
with the following content. It will be used to configure the containers.

```
GID=<id>
DELUGE_UID=<id>
SONARR_UID=<id>
RADARR_UID=<id>
JELLYFIN_UID=<id>
PROWLARR_UID=<id>

MEDIA_DRIVE=<the path you want>
CONFIG=<the path you want>
```

Each service's config will be saved under `${CONFIG}/<service name>`.