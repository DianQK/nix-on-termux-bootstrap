#!/data/data/com.termux/files/usr/bin/bash

set -eu -o pipefail

if [ -z "$USER" ]; then
  echo "The USER environment variable is not set."
fi

apt-get clean
apt-get update
apt-get -y --with-new-pkgs -o Dpkg::Options::="--force-confdef" upgrade

pkg update -y
pkg install x11-repo -y
pkg install termux-x11-nightly proot termux-api git pulseaudio -y

mkdir -p $PREFIX/nix $PREFIX/usr $PREFIX/dev/shm $PREFIX/.l2s $PREFIX/etc/nix $PREFIX/run

if [[ -d "$PREFIX/dbus-1" ]]; then
  mv $PREFIX/dbus-1 $PREFIX/termux-backup-dbus-1
fi


cat << EOF > $PREFIX/etc/nix/nix.conf
experimental-features = nix-command flakes
accept-flake-config = true
substituters = https://cache.nixos.org https://dianqk.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= dianqk.cachix.org-1:n04x/dFNWHbu2kTgTObK8+KJGu4pTV38nUnL93IYbrk=
EOF

echo 'nameserver 8.8.8.8' > $PREFIX/etc/resolv.conf

user_id=$(id -u | tr -d '\n')

cat << EOF > $PREFIX/etc/passwd
root:x:0:0:System administrator:/data/data/com.termux/files/usr/root:/bin/sh
${USER}:x:${user_id}:${user_id}:${USER}:/data/data/com.termux/files/home:/bin/sh
EOF
