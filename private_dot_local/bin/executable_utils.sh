#!/bin/bash

export NAMESERVER=`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`

get_bluestacks_st_adb_port ()
{
  target="$1"
  bs_config=/mnt/e/ProgramData/BlueStacks_nxt/bluestacks.conf
  
  case "$target" in
    "alas")
      echo `sed -n 's/^bst.instance.Rvc64.status.adb_port="\(.*\)"$/\1/p' $bs_config`
      ;;
    "fgo")
      echo `sed -n 's/^bst.instance.Rvc64_2.status.adb_port="\(.*\)"$/\1/p' $bs_config`
      ;;
    "hbr")
      echo `sed -n 's/^bst.instance.Rvc64_3.status.adb_port="\(.*\)"$/\1/p' $bs_config`
  esac
}

ssh_tun_bluestacks()
{
  target=$1

  case "$target" in
    alas)
      pkill -f "ssh -fNL 5565"
      ssh -fNL 5565:127.0.0.1:$(get_bluestacks_st_adb_port $target) leave@$NAMESERVER
      ;;
    fgo)
      pkill -f "ssh -fNL 5566"
      ssh -fNL 5566:127.0.0.1:$(get_bluestacks_st_adb_port $target) leave@$NAMESERVER
      ;;
    hbr)
      pkill -f "ssh -fNL 5567"
      ssh -fNL 5567:127.0.0.1:$(get_bluestacks_st_adb_port $target) leave@$NAMESERVER
      ;;
    *)
      echo "invalid target: $target"
  esac
}

