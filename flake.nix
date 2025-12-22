{
  description = "My Config and Dotfiles for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      # used for macOS configuration
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf?ref=v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake"; # using unstable niri package due to graphical issues with v25.05.1
    # catppuccin.url = "github:catppuccin/nix/release-25.05";
  };
  outputs = {
    nix-darwin,
    home-manager,
    nixpkgs,
    stylix,
    nvf,
    niri,
    ...
  }: let
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-darwin"];
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    darwinConfigurations = {
      macbook = nix-darwin.lib.darwinSystem {
        pkgs = pkgsFor.aarch64-darwin;
        modules = [
          ./macbook.nix
          stylix.darwinModules.stylix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nvf;};
              users.tim = ./macbook-tim.nix;
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      server = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nvf;};
              users.tim = ./server-tim.nix;
            };
          }
          ./server.nix
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nvf;};
              users.tim = ./desktop-tim.nix;
            };
          }
          {
            nixpkgs.overlays = [niri.overlays.niri];
          }
          ./desktop.nix
        ];
      };
    };

    homeConfigurations = {
      "tim@work" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          stylix.homeModules.stylix
          ./home/global.nix
          ./modules/stylix.nix
          ./home/editor/neovim.nix
          ./home/git.nix
          ./home/gpg.nix
        ];
        extraSpecialArgs = {inherit nvf;};
      };
    };

    homeModules.default = import ./home {inherit nvf;};
    nixosModules.default = import ./hosts;
  };
}
