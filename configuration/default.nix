{ self, pkgs, ... }: {
  imports = [
    ./system.nix
    ./packages.nix
    ./homebrew.nix
  ];

  # Set hostname
  # networking.hostName = "Zs-MacBook-Pro";
  # This will set both the device name and local hostname
  
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  #packages.aarch64-darwin.darwinConfigurations.z.system

  nixpkgs.config.allowUnfree = true;

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;
  programs.zsh.enable = true;  # Enable zsh module
  environment.shells = [ pkgs.zsh ];  # Add zsh to allowed shells

}