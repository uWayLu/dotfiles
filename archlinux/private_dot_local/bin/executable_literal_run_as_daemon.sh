#!/bin/bash
cmd="$*"
sudo -u daemon bash -ic "$cmd"
