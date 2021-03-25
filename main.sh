#!/bin/bash

echo "Starting the default changes for Myriad servers"
# Add the new user admin account
echo "Adding the manager account"
echo " > Creating admin account"
useradd -m mnanager
echo " > Adding manager to groups"
useradd -aG adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi
echo " > Setting manager's password"
usermod -p $6$lWdugeBABF0JKPhz$hUqtqQPGRK1BPCvL4cf5yYgcpWdEXE776DBhnljxquQjEzwC04dP3fN6igjbc7GGWkToWUq/1TuaWNrdHva0e0 manager

# diable pi login, but keep the account
echo "Disabling the default 'pi' account'"
usermod -L -e 1 pi

# enable SSH 
echo "Enabling SSH"
echo " > Enabling SSH daemon"
systemctl enable ssh
echo " > Start ssh daaemon"
systemctl start ssh

# do a full upgrade of all packages
echo "Performing full update and upgrade"
echo " > starting update"
apt update 
echo " > starting full upgrade"
apt full-upgrade -y
echo " > cleaning the cache"
apt clean

# download + install docker
echo "Installing Docker"
echo " > downloading executable"
curl -fsSL https://get.docker.com -o get-docker.sh
echo " > running executable"
sh get-docker.sh
echo " > removing file"
rm get-docker.sh

# Installing portainer
echo "Installing portainer"
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

