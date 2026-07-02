#!/bin/bash
config_path="$HOME/.config/fcitx5/profile"
groups=$(grep 'Group Name' -A1 $config_path | grep 'Name=' | awk -F '=' '{print $NF"\n"}')
#groups=$(grep 'Group Name' -A1 $config_path | grep 'Name=')
active_group=$(fcitx5-remote -q)
next_group=$(printf "%s\n" $groups | sed -n "/$active_group/ {n;p;}")
next_group=${next_group:-$(printf "%s\n" $groups | head -n1)}

fcitx5-remote -g $next_group
