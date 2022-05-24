{
  description = "My personal NixOS system configuration flake";

  inputs = {
    # Use the official unstable NixOS packages.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Use the home-manager.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager }:
    let
      user = "dateiexplorer"; 	

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        devman = lib.nixosSystem {
          inherit system;
	      specialArgs = { inherit user; };
          
	      modules = [
	        ./system/configuration.nix 
	  
	        home-manager.nixosModules.home-manager {
	          home-manager.useGlobalPkgs = true;
	          home-manager.useUserPackages = true;
	          home-manager.extraSpecialArgs = { inherit user; };
	          home-manager.users.${user} = {
	            imports = [ ./users/${user}/home.nix ]; 
	          };
	        }
	      ];
        };
      };
    };
}
