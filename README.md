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
DOMAIN=<yourdomain.com>
EMAIL=<your@ema.il>

```

Each service's config will be saved under `${CONFIG}/<service name>`.

If you want to enable HTTPS for your services, fill the DOMAIN variable.
Otherwise, you will still be able to access your services in HTTP (port 80).

Everything is served via Nginx gateway:
deluge.*
sonarr.*
radarr.*
prowlarr.*
jellyfin.*
