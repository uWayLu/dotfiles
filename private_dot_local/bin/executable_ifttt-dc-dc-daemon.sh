#!/bin/bash

WEBHOOK_URL="https://discord.com/api/webhooks/1267372677354491904/CJHw7_1HBc_f6zL5AmlwBLRlS_s8mwWdVzaygLYJaVG46rCEEdQPmN01--nW2VnRsT_J"

send_discord_notification() {
    container_name=$1
    message="Container '$container_name' has been restarted."
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"$message\"}" \
         $WEBHOOK_URL
}

monitor_docker_events() {
    docker events --filter 'event=restart' | while read event
    do
        container_name=$(echo $event | grep -oP '(?<=name=)[^)]*')
        send_discord_notification $container_name
    done
}

monitor_docker_events

