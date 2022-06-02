# This is a flake file. Flakes are mentioned to be a replacement for the
# 'nix-channels'. With a flake.lock file you can lock the revisions of the
# outputs to build hermenistic and fully reproducable builds.

{
  # Every flake has a description, that describes what this flake contains.
  description = "My personal NixOS system configuration flake";

  # inputs defines all dependencies of a flake.
  # Dependencies that are registered in the global registry doesn't need
  # an entry here.
  inputs = {
    # Use the official unstable NixOS packages.
    # This input isn't really necessary because the nixpkgs are always in the
    # registry. You can use 'nix registry list' to get all global registered
    # flakes.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use the home-manager.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs defines all outputs of this flake. This can be anything, form
  # builds, derivations (packages) or configurations.
  outputs = { self, nixpkgs, home-manager }:
    let
      # Define some variables used in the outputs.

      # Define the admin user of this system. This is a normal user but has
      # sudo privileges.
      # User configurations are the same for a user through all system
      # configurations.
      user = {
        name = "dateiexplorer";
        description = "Justus Röderer";
        email = "mail@dateiexplorer.de";
      };

      # Define the architecture of the system.
      system = "x86_64-linux";

      # Define aliases for nixpkgs to be convenient with the non-flake way of
      # doing things.
      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      # Create a new configuration for NixOS on 'devman'.
      nixosConfigurations.devman = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit user; };

        modules = [
          ./systems/devman/configuration.nix

          # Setup home manager for the specific user.
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user.name} = {
              imports = [ ./users/${user.name}/home.nix ];
            };
          }
        ];
      };

      # This is experimental.
      templates = import ./templates;

      # Apply the ability to format this flake with 'nix fmt' command
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
