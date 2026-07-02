#!/usr/bin/env bash
set -uo pipefail

MODE="connect"
PORT=""
RANGE="30000-50000"
CODE=""
IP=""

usage() {
  cat <<EOF
Usage:
  $0 <ip> [--mode connect|pair] [--port port] [--code pairing_code]

Examples:
  $0 192.168.1.23
  $0 192.168.1.23 --port 37555
  $0 192.168.1.23 --mode pair --port 41234
  $0 192.168.1.23 --mode pair --code 123456

Options:
  --mode    connect or pair, default: connect
  --port    port to try before scanning
  --code    optional pairing code for adb pair
EOF
}

die() {
  echo "Error: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing command: $1"
}

valid_port() {
  [[ "$1" =~ ^[0-9]+$ ]] && (( "$1" >= 1 && "$1" <= 65535 ))
}

scan_ports() {
  local ip="$1"

  nmap -n -Pn --open "$ip" -p "$RANGE" 2>/dev/null \
    | awk -F/ '/tcp open/{print $1}' \
    | awk 'NF'
}

try_connect() {
  local ip="$1"
  local port="$2"
  local out

  echo "Trying adb connect ${ip}:${port} ..."
  out="$(adb connect "${ip}:${port}" 2>&1 || true)"
  echo "$out"

  echo "$out" | grep -Eiq 'connected to|already connected to'
}

try_pair() {
  local ip="$1"
  local port="$2"

  echo "Trying adb pair ${ip}:${port} ..."

  if [[ -n "$CODE" ]]; then
    adb pair "${ip}:${port}" "$CODE"
  else
    adb pair "${ip}:${port}"
  fi
}

try_port() {
  local ip="$1"
  local port="$2"

  case "$MODE" in
    connect)
      try_connect "$ip" "$port"
      ;;
    pair)
      try_pair "$ip" "$port"
      ;;
    *)
      die "invalid mode: $MODE"
      ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      shift
      [[ $# -gt 0 ]] || die "--mode needs a value"
      MODE="$1"
      ;;
    --mode=*)
      MODE="${1#*=}"
      ;;
    --port)
      shift
      [[ $# -gt 0 ]] || die "--port needs a value"
      PORT="$1"
      ;;
    --port=*)
      PORT="${1#*=}"
      ;;
    --code)
      shift
      [[ $# -gt 0 ]] || die "--code needs a value"
      CODE="$1"
      ;;
    --code=*)
      CODE="${1#*=}"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      die "unknown option: $1"
      ;;
    *)
      if [[ -z "$IP" ]]; then
        IP="$1"
      else
        die "unexpected argument: $1"
      fi
      ;;
  esac

  shift
done

[[ -n "$IP" ]] || {
  usage
  exit 1
}

[[ "$MODE" == "connect" || "$MODE" == "pair" ]] || die "--mode must be connect or pair"

if [[ -n "$PORT" ]]; then
  valid_port "$PORT" || die "invalid port: $PORT"
fi

need_cmd adb
need_cmd nmap
need_cmd awk

adb start-server >/dev/null

declare -a CANDIDATES=()
declare -A SEEN=()

add_port() {
  local p="$1"
  valid_port "$p" || return 0

  if [[ -z "${SEEN[$p]:-}" ]]; then
    CANDIDATES+=("$p")
    SEEN[$p]=1
  fi
}

if [[ -n "$PORT" ]]; then
  add_port "$PORT"

  echo "Preferred port specified: $PORT"
  if try_port "$IP" "$PORT"; then
    echo "Success: ${MODE} ${IP}:${PORT}"
    exit 0
  fi

  echo "Preferred port failed, scanning ${IP}:${RANGE} ..."
else
  echo "Scanning ${IP}:${RANGE} ..."
fi

while read -r p; do
  add_port "$p"
done < <(scan_ports "$IP")

if [[ "${#CANDIDATES[@]}" -eq 0 ]]; then
  die "no open adb-like port found in ${RANGE}"
fi

for p in "${CANDIDATES[@]}"; do
  [[ -n "$PORT" && "$p" == "$PORT" ]] && continue

  if try_port "$IP" "$p"; then
    echo "Success: ${MODE} ${IP}:${p}"
    exit 0
  fi
done

die "failed to ${MODE} ${IP}; tried ports: ${CANDIDATES[*]}"

