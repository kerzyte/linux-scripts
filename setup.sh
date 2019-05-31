#!/bin/sh

# Configure pacman Mirror and Install Packages
echo 'Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
pacman -Syu --needed --noconfirm git nginx-mainline openssh vim

# Add SSH Public Key
# Linode can now add public keys on creation
#mkdir -m700 /root/.ssh
#echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBONQCATfAF1D5vB1Smq70PVr3/mkqWNpDjr7UEyP57 ' >> /root/.ssh/authorized_keys
#chmod 600 /root/.ssh/authorized_keys

# Configure sshd
sed -i 's/# Ciphers and keying/# Ciphers and keying\nKexAlgorithms -diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1\nMACs -umac-64-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,hmac-sha1/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# Delete root Password
passwd -d root

# Configure git
git config --global user.name Kerzyte
git config --global user.email 1848038+kerzyte@users.noreply.github.com

# Configure nginx
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.pacnew
mv /etc/nginx/mime.types /etc/nginx/mime.types.pacnew
#systemctl start nginx
#systemctl enable nginx

# Configure vim
sed -i 's/"let skip_defaults_vim=1/let skip_defaults_vim=1/' /etc/vimrc

# Set Hostname
echo twilight-sparkle > /etc/hostname
hostname twilight-sparkle
