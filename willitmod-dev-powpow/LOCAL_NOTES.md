# PowPow Dev Store Notes

This package is now wired to the real PowPow stack.

## Current status

- Uses GHCR images published from `WillItMod/PowPow_Build`
- App image: `ghcr.io/willitmod/powpow-app:0.2.0-dev`
- Service images:
  - `ghcr.io/willitmod/powpow-litecoin:0.2.0-dev`
  - `ghcr.io/willitmod/powpow-dogecoin:0.2.0-dev`
  - `ghcr.io/willitmod/powpow-pool:0.2.0-dev`
- Miner endpoint hint is derived from the host OS IP via `${NETWORK_IP}`
- In-app UI displays `PowPow v0.2.0` with the `DEV` pill and experimental warning banner

## Packaging notes

- The stale DigiByte/Miningcore package content is ignored via `.gitignore`
- PostgreSQL schema init files are copied from `PowPow_Build/postgres/init`
- `docker-compose.yml` now represents the PowPow-native stack:
  - `app`
  - `litecoin`
  - `dogecoin`
  - `pool`
  - `postgres`

## Deployment note

This is still a DEV app. It should go to the dev store only until there is enough runtime validation on real hosts.
