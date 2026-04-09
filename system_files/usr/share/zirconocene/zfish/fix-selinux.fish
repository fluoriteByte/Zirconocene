#!/bin/env fish

echo "This script will copy all files from /etc/selinux into /var/lib, please only run if you understand what you are doing!!!"

if ! gum confirm
    exit 0
end

run0 bash -c \
    " {
        setenforce 0
        cp --reflink=auto /etc/selinux/ /var/lib/
        reboot
    }"