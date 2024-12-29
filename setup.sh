#! /bin/sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix run nix-darwin -- switch --flake ~/.config/nix-darwin#kaluza-mbp
