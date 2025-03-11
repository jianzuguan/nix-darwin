{ pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.act
      pkgs.coreutils
      pkgs.fnm
      pkgs.gh
      pkgs.git
      pkgs.jq
      pkgs.kind
      pkgs.kubectl
      pkgs.kubectx
      pkgs.kubelogin-oidc
      pkgs.kubernetes-helm
      pkgs.temporal-cli
      pkgs.vim
      pkgs.yarn-berry
      pkgs.zoxide
    ];
}