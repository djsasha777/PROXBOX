#!/bin/bash
# This script will install dns server and dns configs on dns-single-node-server
# sudo dnf install -y epel-release
# set -e #uncheck for debugging mode
# sudo dnf update -y
cd
mkdir installdir
cd installdir
sudo dnf -y install bind bind-utils wget tar git dhcp-server nano haproxy httpd

git clone https://github.com/djsasha777/provision.git

nmcli connection modify ens18 connection.zone external
nmcli connection modify ens19 connection.zone internal

#configure zones
firewall-cmd --zone=external --add-masquerade --permanent
firewall-cmd --zone=internal --add-masquerade --permanent
firewall-cmd --reload

#configure dhcp
cp -fr provision/bash/okd-mb-full2/dhcpd.conf /etc/dhcp/dhcpd.conf
firewall-cmd --add-service=dhcp --zone=internal --permanent
firewall-cmd --reload
sudo systemctl enable dhcpd
sudo systemctl start dhcpd

# dns configure
echo "dns files configure"
sudo cp -fr provision/bash/okd-mb-full2/named.conf /etc/named.conf
sudo mkdir /etc/named/zones
sudo cp -fr provision/bash/okd-mb-full2/db* /etc/named/zones
sudo systemctl enable named
sudo systemctl start named

#add firewall rules
echo "adding firewall rules"
sudo firewall-cmd --permanent --add-port=53/udp --zone=internal
sudo firewall-cmd --reload

echo "DNS server configuration finished! "

#  LOAD BALANCER install

echo "HAproxy server software is installed! now configuring!"
setsebool -P haproxy_connect_any=1
sudo systemctl enable haproxy
sudo systemctl restart haproxy  
echo "haproxy installation and configuration is DONE"
echo "add firewall rules"
sudo firewall-cmd --permanent --add-port=6443/tcp --zone=internal
sudo firewall-cmd --permanent --add-port=22623/tcp --zone=internal
sudo firewall-cmd --permanent --add-service=http --zone=internal
sudo firewall-cmd --permanent --add-service=https --zone=internal
sudo firewall-cmd --reload
echo "firewall rules added"

#httpd install
sudo sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
sudo setsebool -P httpd_read_user_content 1
sudo systemctl enable httpd
sudo systemctl start httpd
sudo firewall-cmd --permanent --add-port=8080/tcp --zone=internal
sudo firewall-cmd --reload

wget ftp://192.168.1.1/AiDisk_a1/repository/openshift-client-linux-4.12.0-0.okd-2023-03-05-022504.tar.gz
wget ftp://192.168.1.1/AiDisk_a1/repository/openshift-install-linux-4.12.0-0.okd-2023-03-05-022504.tar.gz

#Extract the okd version of the oc client and openshift-install:
tar -zxvf openshift-client-linux-4.12.0-0.okd-2023-03-05-022504.tar.gz
tar -zxvf openshift-install-linux-4.12.0-0.okd-2023-03-05-022504.tar.gz

#Move the kubectl, oc, and openshift-install to /usr/local/bin and show the version:
sudo mv kubectl oc openshift-install /usr/local/bin/

#generate ssh key
sudo ssh-keygen -f cluster-install-ssh -t rsa -b 2048 -q -N ""
SSHKEY=$(sudo cat cluster-install-ssh.pub)
sudo sed -Ei "s|SSHKEY|$SSHKEY|g" install-config.yaml

echo "please enter pull secret"
read -r PULLSECRET
sudo sed -Ei "s|PULLSECRET|$PULLSECRET|g" install-config.yaml

cd
openshift-install create manifests --dir=installdir/
# This lines disables schedule application pods on the master nodes 
sed -i 's/mastersSchedulable: true/mastersSchedulable: False/' installdir/manifests/cluster-scheduler-02-config.yml
openshift-install create ignition-configs --dir=installdir/

rm -drf /var/www/html/okd4
sudo mkdir /var/www/html/okd4

sudo cp -R installdir/* /var/www/html/okd4/
sudo chown -R apache: /var/www/html/
sudo chmod -R 755 /var/www/html/


