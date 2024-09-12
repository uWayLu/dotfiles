#!/bin/bash

tmpfile="/tmp/slurp-output"

while true; do
    inotifywait -e modify "$tmpfile"

    geo=$(cat "$tmpfile")
    if [ -n "$geo" ]; then
        grim -g "$geo" - | wl-copy
    else
        echo "No area selected."
    fi
done

