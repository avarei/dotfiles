{
  description = "General Purpose Configuration for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nix-darwin, nix-homebrew, home-manager, nixpkgs, nixvim, ... }@inputs:
    let
      username = "tim";
      overlays = [ ];
    in {
      # devShells = forAllSystems devShell;
      devShell."provider-vault" =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gnumake
            go
            kubernetes-helm
          ];
        };

      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            {
              users.users.${username}.home = "/Users/${username}";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" = import ./home.nix;
                extraSpecialArgs = { inherit username nixvim; };
              };
            }
            ./hosts/common
            ./hosts/darwin
          ];
        };

      nixosConfigurations."server" = nixpkgs.lib.nixosSystem { 
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          {
            users.users.${username}.home = "/home/${username}";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."${username}" = import ./home.nix;
              extraSpecialArgs = { inherit username nixvim; };
            };
          }
          ./hosts/common
          ./hosts/nixos
        ];
      };
    };
}
