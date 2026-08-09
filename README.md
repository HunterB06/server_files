# Media Server

A self-hosted media server stack orchestrated with Docker Compose. It bundles a
downloader, indexer manager, TV/movie automation tools and a media player behind
a single Nginx reverse proxy that can optionally serve everything over HTTPS.

## Services

| Service      | Role                                     | Internal port(s)     | Subdomain    |
|--------------|------------------------------------------|----------------------|--------------|
| deluge       | BitTorrent client / downloader           | 8112                 | `deluge.*`   |
| sonarr       | TV series automation                     | 8989                 | `sonarr.*`   |
| radarr       | Movie automation                         | 7878                 | `radarr.*`   |
| prowlarr     | Indexer manager for sonarr/radarr        | 9696                 | `prowlarr.*` |
| flaresolverr | Cloudflare challenge solver for prowlarr | 8191                 | *(internal)* |
| jellyfin     | Media library / player                   | 8096, 8920, 7359/udp | `jellyfin.*` |
| nginx        | Reverse proxy + HTTPS (Let's Encrypt)    | 80, 443              | gateway      |
| init         | One-shot volume permission setup         | —                    | —            |

All services are attached to a private `media-server-network` bridge. Only
`nginx` publishes ports to the host (80 and 443); every other service is reached
through the proxy.

## User & permission model

Each application runs as its **own dedicated user** (its own UID), but every
container also shares a **common group** (`media`, set via the `GID` variable).

- The `init` service runs first and prepares the media drive: it `chgrp`s
  `/data` to the shared `GID` and applies `chmod g+sw` so the directory is
  group-writable with the *setgid* bit. New files created under it inherit the
  shared group.
- Every service entrypoint sets `umask 002`, so newly created files are
  group-writable.
- Applications drop privileges with `gosu <user>:<GID>` and their config
  directories are `chown`ed to `<UID>:<GID>` on start.

The result: each app is isolated under its own user, yet they can all read and
write the shared downloaded media because they belong to the same group. The
`init` service must complete successfully before the media-consuming services
(`deluge`, `sonarr`, `radarr`, `jellyfin`) start.

> `prowlarr` and `flaresolverr` do not touch the media drive, so they don't
> depend on `init`.

## Volumes & data layout

- `MEDIA_DRIVE` is mounted as `/data` in most services (and as `/media` in
  jellyfin). This is where downloads and the media library live.
- `CONFIG` holds per-service persistent configuration. Each service's config is
  stored under `${CONFIG}/<service name>`.
- Named Docker volumes `certificates` and `nginx-conf` persist the Let's Encrypt
  certificates and the generated Nginx configuration.

## HTTPS / reverse proxy

Everything is served through the Nginx gateway using subdomain routing:

```
deluge.<domain>
sonarr.<domain>
radarr.<domain>
prowlarr.<domain>
jellyfin.<domain>
```

- If `DOMAIN` is **not** set, Nginx runs in plain **HTTP mode** on port 80.
- If `DOMAIN` **is** set, Nginx runs in **HTTPS mode**: on first start it
  requests a single Let's Encrypt certificate (via certbot) covering all five
  subdomains, enables HTTP→HTTPS redirect, and then renews it automatically
  (a background loop runs `certbot renew` every 12 hours).

Make sure the five subdomains resolve to your host and that ports 80/443 are
reachable before enabling HTTPS, as certbot needs them for the ACME challenge.

## Configuration (`.env`)

Create a `.env` file at the root of the repository (same level as
`compose.yml`). It is git-ignored. Use the following template:

```dotenv
# Shared group id used by all containers to access the media drive
GID=<id>

# Per-service user ids (each service runs under its own user)
DELUGE_UID=<id>
SONARR_UID=<id>
RADARR_UID=<id>
JELLYFIN_UID=<id>
PROWLARR_UID=<id>

# Paths on the host
MEDIA_DRIVE=<path to your media drive>
CONFIG=<path where service configs are stored>

# HTTPS (optional). Leave DOMAIN empty to serve over HTTP only.
DOMAIN=<yourdomain.com>
EMAIL=<your@ema.il>
```

- `GID` — the shared group id granting access to `MEDIA_DRIVE`.
- `*_UID` — a distinct user id per service for isolation.
- `MEDIA_DRIVE` / `CONFIG` — host paths for media and configuration.
- `DOMAIN` / `EMAIL` — set both to enable HTTPS with Let's Encrypt.

## Usage

Build and start the whole stack:

```sh
docker compose up -d --build
```

View logs (e.g. for the proxy or a single service):

```sh
docker compose logs -f nginx
docker compose logs -f jellyfin
```

Stop everything:

```sh
docker compose down
```

Once running, access each app at `http://<service>.<domain>` (or `https://`
when `DOMAIN` is configured), for example `http://jellyfin.<domain>`.
