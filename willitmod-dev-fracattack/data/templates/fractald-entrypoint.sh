#!/bin/sh
set -eu

echo "[fracattack] fractald entrypoint starting"

if ! command -v bitcoind >/dev/null 2>&1; then
  echo "[fracattack] ERROR: bitcoind not found in PATH"
  exit 127
fi

extra=""
if [ -f /data/btc_wipe_request ]; then
  echo "[fracattack] Full Fractal chain wipe requested."
  rm -rf /data/blocks /data/chainstate /data/indexes
  rm -f /data/.lock /data/bitcoind.pid /data/mempool.dat /data/fee_estimates.dat /data/peers.dat
  rm -f /data/.reindex-chainstate /data/btc_wipe_request
  echo "[fracattack] Fractal chain data removed; starting fresh sync."
fi

if [ -f /data/.reindex-chainstate ]; then
  echo "[fracattack] Reindex requested (chainstate)."
  rm -f /data/.reindex-chainstate || true
  extra="-reindex-chainstate"
fi

dbcache="${BTC_DBCACHE_MB:-}"
if [ -z "${dbcache}" ]; then
  mem_kb="$(awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo 0)"
  mem_mb="$((mem_kb / 1024))"
  # Conservative by default, but give larger SSD-backed nodes a little more
  # cache during the long initial Fractal sync.
  if [ "$mem_mb" -ge 12000 ]; then
    dbcache="$((mem_mb / 6))"
    max_dbcache=4096
  elif [ "$mem_mb" -ge 7000 ]; then
    dbcache="$((mem_mb / 6))"
    max_dbcache=2048
  else
    dbcache="$((mem_mb / 8))"
    max_dbcache=1024
  fi
  if [ "$dbcache" -lt 256 ]; then dbcache=256; fi
  if [ "$dbcache" -gt "$max_dbcache" ]; then dbcache="$max_dbcache"; fi
fi

echo "[fracattack] Using dbcache=${dbcache}MB"
echo "[fracattack] Exec: bitcoind -datadir=/data -printtoconsole -dbcache=${dbcache} $extra"
exec bitcoind -datadir=/data -printtoconsole -dbcache="${dbcache}" $extra
