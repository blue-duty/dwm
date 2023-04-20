#! /bin/bash

dd if=/dev/zero of=/root/swapfile bs=1M count=8192
mkswap /root/swapfile
swapon /root/swapfile

