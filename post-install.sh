#! /bin/bash

distro_name="GentooWSL"

echo
echo "[*] Executing $distro_name post-installation procedure"

echo
echo "[*] Selecting the Gentoo source mirrors"
sed -i "s/GENTOO_MIRRORS/#GENTOO_MIRRORS/g" /etc/portage/make.conf || exit $?
mirrorselect -i -o >> /etc/portage/make.conf || exit $?

echo
echo "[*] Selecting the Gentoo rsync mirrors"
mkdir /etc/portage/repos.conf || exit $?
cp /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf || exit $?

sed -i "s/sync-uri/#sync-uri/g" /etc/portage/repos.conf/gentoo.conf || exit $?
mirrorselect -i -r -o >> /etc/portage/repos.conf/gentoo.conf || exit $?

echo
echo "[*] Changing password for root"
passwd || exit $?

echo
echo "[*] Creating new regular user with UID 1000"
read -p "New username: " -r wsl_username
groupdel -f docker
useradd -m -u 1000 -G wheel $wsl_username || exit $?

echo
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/allow-wheels-nopasswd
echo "[*] Changing password for $wsl_username"
passwd $wsl_username || exit $?

groupadd docker || exit $?
usermod -aG docker $wsl_username || exit $?

mv -f .bashrc~ .bashrc || exit $?
rm -f post-install.sh || exit $?

echo
source .bashrc
