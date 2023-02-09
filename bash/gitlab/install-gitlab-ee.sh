#!/bin/bash

# Installing gitlab-ee

if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]
    then
        echo " It's a Debian based system"
        apt update
        apt upgrade -y
        apt install -y nano curl openssh-server ca-certificates tzdata perl postfix
        wget ftp://192.168.1.1/AiDisk_a1/repository/gitlab-ee_15.6.7-ee.0_amd64.deb
        EXTERNAL_URL="https://172.22.22.115" dpkg -i gitlab-ee_15.6.7-ee.0_amd64.deb
        dpkg -i gitlab-ee_15.6.7-ee.0_amd64.deb
        cat /etc/gitlab/initial_root_password

elif [ "$(grep -Ei 'fedora|redhat|centos' /etc/*release)" ]
    then
        echo "It's a RedHat based system."
        dnf install -y nano curl openssh-server ca-certificates tzdata perl postfix
        wget ftp://192.168.1.1/AiDisk_a1/repository/gitlab-ee_15.6.7-ee.0_amd64.deb
        EXTERNAL_URL="https://172.22.22.115" dpkg -i gitlab-ee_15.6.7-ee.0_amd64.deb
        dnf -i gitlab-ee_15.6.7-ee.0_amd64.deb
        cat /etc/gitlab/initial_root_password
else
    echo "This script doesn't support gitlab installation on this OS."
fi
