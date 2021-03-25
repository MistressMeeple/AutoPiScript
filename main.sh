#!/bin/bash

echo "Starting the default changes for Myriad servers"
# Add the new user admin account
while [ x$username = "x" ]; do
read -p "Please enter the username you wish to create : " username
if id -u $username >/dev/null 2>&1; then
echo "User already exists"
username=""
fi
done
echo "Adding the $username account"
useradd -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi -m $username
echo "Now to set password"
passwd $username

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

