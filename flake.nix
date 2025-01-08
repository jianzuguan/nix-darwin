{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, ... }: {
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

      system.defaults = {
        dock.autohide = true;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
        finder.ShowStatusBar = true;
      };

      security.pam.enableSudoTouchIdAuth = true;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;  # Enable zsh module
      environment.shells = [ pkgs.zsh ];  # Add zsh to allowed shells

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
      
      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
        
        # CLI packages
        brews = [
          "awscli"
          "stow"
          "tfenv"
        ];

        # GUI applications
        casks = [
          "alt-tab"
          "arc"
          "grammarly-desktop"
          "logi-options+"
          "obsidian"
          "ollama"
          "stats"
          "visual-studio-code"
        ];

        masApps = {
          "bitwarden" = 1352778147;
          "whatsapp-messenger" = 310633997;
        };
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Zs-MacBook-Pro
    darwinConfigurations."kaluza-mbp" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        {
          users.users.z.home = "/Users/z";
        }
        nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "z";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
      ];
    };
  };
}
