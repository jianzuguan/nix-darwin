{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.coreutils
          pkgs.fnm
          pkgs.gh
          pkgs.git
          pkgs.vim
          pkgs.zoxide
        ];
      
      programs.zsh.enable = true;  # Enable zsh module
      environment.shells = [ pkgs.zsh ];  # Add zsh to allowed shells

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
        
        # CLI packages
        brews = [
          "tfenv"
        ];

        # GUI applications
        casks = [
          "alt-tab"
          "arc"
          "bitwarden"
          "grammarly-desktop"
          "logi-options+"
          "obsidian"
          "ollama"
          "stats"
          "visual-studio-code"
        ];
      };

      nixpkgs.config.allowUnfree = true; 

      # Set hostname
      # networking.hostName = "Zs-MacBook-Pro";
      # This will set both the device name and local hostname
      
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      #packages.aarch64-darwin.darwinConfigurations.z.system
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Zs-MacBook-Pro
    darwinConfigurations."z" = nix-darwin.lib.darwinSystem {
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
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.z = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
      ];
    };
  };
}
