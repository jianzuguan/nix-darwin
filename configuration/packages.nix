{ pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.coreutils
      pkgs.fnm
      pkgs.gh
      pkgs.git
      pkgs.jq
      pkgs.vim
      pkgs.zoxide
    ];
  
}