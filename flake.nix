{
  description = "nix-darwin system flake";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager }:
  let
    username = "z";
    hostname = "kaluza-mbp";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#kaluza-mbp
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      modules = [ 
        ({ ... }: { _module.args = { inherit self; }; })
        ./configuration
        {
          users.users.${username}.home = "/Users/${username}";
        }
        nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = username;

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
      ];
    };
  };
}
