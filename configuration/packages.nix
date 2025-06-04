{ pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.act
      pkgs.corepack
      pkgs.coreutils
      pkgs.fnm
      pkgs.fzf
      pkgs.gh
      pkgs.git
      pkgs.graphite-cli
      pkgs.jdk21_headless
      pkgs.jq
      pkgs.kind
      pkgs.kubectl
      pkgs.kubectx
      pkgs.kubelogin-oidc
      pkgs.kubernetes-helm
      pkgs.sbt
      pkgs.sqlite
      pkgs.temporal-cli
      pkgs.vim
      pkgs.zoxide
    ];
}