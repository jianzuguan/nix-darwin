{ pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.act
      pkgs.coreutils
      # pkgs.fnm
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
      pkgs.kubeseal
      pkgs.nh
      pkgs.sbt
      pkgs.sqlite
      pkgs.temporal-cli
      pkgs.vim
      pkgs.yq-go
      pkgs.zoxide
    ];
}