{
  description = "General Purpose Configuration for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    niri.url = "github:sodiboo/niri-flake";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
  };
  outputs = { self, nix-darwin, home-manager, nixpkgs, nixvim, niri, ... }@inputs:
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
        desktop = nixpkgs.lib.nixosSystem { 
          pkgs = pkgsFor.x86_64-linux;
          modules = [
            {
              nixpkgs.overlays = [ niri.overlays.niri ];
            }
            ./hosts/desktop
          ];
        };
        test = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor.x86_64-linux;
          modules = [
            ./hosts/test.nix
          ];
        };
      };


      homeConfigurations = {
        "tim@server" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/tim/server.nix ];
          extraSpecialArgs = { inherit nixvim; };
        };
        "tim@desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/tim/desktop.nix ];
          extraSpecialArgs = { inherit nixvim; };
        };
        "tim@test" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [ ./home/tim/test.nix ];
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

