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

        # customize trackpad
        trackpad = {
          # tap - 轻触触摸板, click - 点击触摸板
          Clicking = true;  # enable tap to click(轻触触摸板相当于点击)
          TrackpadRightClick = true;  # enable two finger right click
          # TrackpadThreeFingerDrag = true;  # enable three finger drag
        };

        # Customize settings that not supported by nix-darwin directly
        # see the source code of this project to get more undocumented options:
        #    https://github.com/rgcr/m-cli
        # 
        # All custom entries can be found by running `defaults read` command.
        # or `defaults read xxx` to read a specific domain.
        CustomUserPreferences = {
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
            _FXSortFoldersFirst = true;
            # When performing a search, search the current folder by default
            FXDefaultSearchScope = "SCcf";
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.WindowManager" = {
            EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          # Prevent Photos from opening automatically when devices are plugged in
          "com.apple.ImageCapture".disableHotPlug = true;
        };
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
          "beekeeper-studio"
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
