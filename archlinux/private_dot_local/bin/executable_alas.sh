#!/bin/sh

PORT=${1:-22267}
BROWSER=${2:-brave}
REMOTE=ywl-ryzen7

TUN="ssh -M -fNL $PORT:127.0.0.1:$PORT $REMOTE"
pkill -f "$TUN"
$($TUN)

$BROWSER --app="http://127.0.0.1:$PORT" -incognito

