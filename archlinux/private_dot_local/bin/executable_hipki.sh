#!/bin/bash

WORKDIR=/opt/HiPKILocalSignServerApp

if systemctl is-active --quiet pcscd.service; then
    cd $WORKDIR
    ./start.sh
else
    echo "pcscd.service is not running. Exiting..."
    exit 1
fi

