#!/data/data/com.termux/files/usr/bin/bash

sh <(curl -L https://nixos.org/nix/install) --no-daemon

source $HOME/.nix-profile/etc/profile.d/nix.sh

export NIX_SSL_CERT_FILE=$(nix-env -q --out-path nss-cacert | awk '{print $2 "/etc/ssl/certs/ca-bundle.crt"}')

mkdir -p /etc/ssl/certs
ln -s $NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt

echo "You need to run the following command to add the nix command to your PATH."
echo "source $HOME/.nix-profile/etc/profile.d/nix.sh"
