#!/bin/bash
#echo -e "Uninstalling OpenSSH server"
#sudo apt remove --purge openssh-server -y

echo -e "installing required development tools,build essentials and other tools"
sudo apt install build-essential zlib1g-dev libssl-dev -y && sudo apt install libpam0g-dev libselinux1-dev -y
sudo rm -rf /etc/ssh
sudo mkdir /var/lib/sshd
sudo chmod -R 700 /var/lib/sshd/
sudo chown -R root:sys /var/lib/sshd/
sudo useradd -r -U -d /var/lib/sshd/ -c "sshd privsep" -s /bin/false sshd

echo -e "Downloading openssh source"
wget -P /tmp/ http://deb.debian.org/debian/pool/main/o/openssh/openssh_8.3p1.orig.tar.gz && tar -xzf /tmp/openssh_8.3p1.orig.tar.gz -C /tmp/ &&  pushd /tmp/openssh-8.3p1/ > /dev/null

echo -e "Enter desired SSH version name"
read sshversion
file=/tmp/openssh-8.3p1/version.h
cat <<EOF > "${file}" 
#define SSH_VERSION	"$sshversion"
#define SSH_PORTABLE	"l2"
#define SSH_RELEASE	SSH_VERSION SSH_PORTABLE
EOF

#echo -e "Compiling and Installing OpenSSH from source"
cd /tmp/openssh-8.3p1/
sudo ./configure --with-md5-passwords --with-pam --with-selinux --with-privsep-path=/var/lib/sshd/ --sysconfdir=/etc/ssh --prefix=/usr && sudo make && sudo make install 
