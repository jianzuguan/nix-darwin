{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "z";
  home.homeDirectory = "/Users/z";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    userName = "Jianzu Guan";
    userEmail = "git@jzg.fastmail.com";

    aliases = {
      a = "add";
      b = "branch";
      c = "checkout";
      s = "status";
    };

    extraConfig = {
      core = {
        excludesFile = "$HOME/.config/git/ignore";
      };
      
      init = {
        defaultBranch = "main";
      };
      
      pull = {
        rebase = true;
      };
      
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
    };
  };
}