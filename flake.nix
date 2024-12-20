{
  description = "General Purpose Configuration for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, darwin, nix-homebrew, home-manager, nixpkgs, nixvim, ... }@inputs:
    let
      username = "tim";
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
      devShell = system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = with pkgs;
            mkShell {
              nativeBuildInputs = with pkgs; [
                bashInteractive
                git
                age
                age-plugin-yubikey
              ];
            };
        };
      homeConfiguration = system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            nixvim.homeManagerModules.nixvim
	    ./home.nix
          ];

          extraSpecialArgs = { inherit inputs username; };
        };
    in {
      devShells = forAllSystems devShell;
      homeConfigurations = forAllSystems homeConfiguration;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.darwinModules.home-manager
            # nix-homebrew.darwinModules.nix-homebrew
            ./hosts/darwin
          ];
        });

      nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
            ./hosts/nixos
          ];
        });
    };
}
