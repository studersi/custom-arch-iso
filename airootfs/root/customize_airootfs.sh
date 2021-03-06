#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/zsh student

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

systemctl disable dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service

echo setxkbmap -layout ch >> /home/student/.xinitrc
echo exec startxfce4 >> /home/student/.xinitrc

# rm /etc/systemd/system/getty@tty1.service.d/autologin.conf
sed -i "s/root/student/g" /etc/systemd/system/getty@tty1.service.d/autologin.conf

echo startx >> /etc/profile

pacman -Syy
