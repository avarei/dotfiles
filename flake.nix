{
  description = "General Purpose Configuration for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nix-darwin, home-manager, nixpkgs, nixvim, ... }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in {
      # devShells = forAllSystems devShell;
      devShells.x86_64-linux."provider-vault" =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gnumake
            go
            kubernetes-helm
          ];
        };

      darwinConfigurations = {
        macbook = nix-darwin.lib.darwinSystem {
          pkgs = pkgsFor.aarch64-darwin;
          modules = [
            ./hosts/macbook
          ];
        };
      };

      nixosConfigurations = {
        server = nixpkgs.lib.nixosSystem { 
          pkgs = pkgsFor.x86_64-linux;
          modules = [
            ./hosts/server
          ];
        };
      };

      homeConfigurations = {
        "tim@server" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/tim/server.nix ];
          extraSpecialArgs = { inherit nixvim; };
        };
        "tim@macbook" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.aarch64-darwin;
          modules = [ ./home/tim/macbook.nix ];
          extraSpecialArgs = { inherit nixvim; };
        };
      };
    };
}

