#!/bin/bash

# Add the manager
echo "Adding the manager account"
useradd -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi -m  -p $6$lWdugeBABF0JKPhz$hUqtqQPGRK1BPCvL4cf5yYgcpWdEXE776DBhnljxquQjEzwC04dP3fN6igjbc7GGWkToWUq/1TuaWNrdHva0e0 manager

# diable pi login, but keep the account
echo "Disabling the default 'pi' account'"
usermod -L -e 1 pi

# enable SSH 
echo "Enabling SSH"
systemctl enable ssh
systemctl start ssh

# do a full upgrade of all packages
echo "Performing full update and upgrade"
apt update 
apt full-upgrade -y

# download + install docker
echo "Installing Docker"
curl -fsSL https://get.docker.com -o get-docker.sh 
sh get-docker.sh

# Installing portainer
echo "Installing portainer"
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

