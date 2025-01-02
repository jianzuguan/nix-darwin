#! /bin/sh

curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix \
  | sh -s -- install --no-confirm

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix run nix-darwin -- switch --flake ~/.config/nix-darwin#kaluza-mbp
