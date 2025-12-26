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
    self,
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
          self.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            system.stateVersion = 5;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.tim = {config, ...}: {
                dotfiles = {
                  editor.neovim.enable = true;
                  git.enable = true;
                  shell.nushell.enable = true;
                  shell.zsh.enable = true;
                  shell.tmux.enable = true;
                  gpg.enable = true;
                  gpg-agent.enable = true;
                  gui.ghostty.enable = false;
                };
                home = {
                  homeDirectory = lib.mkForce "/Users/${config.home.username}";
                };
              };
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      server = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.tim = {...}: {
                dotfiles = {
                  editor.neovim.enable = true;
                  git.enable = true;
                  shell.nushell.enable = true;
                  shell.zsh.enable = true;
                  shell.tmux.enable = true;
                  gpg.enable = true;
                  selfhosted = {
                    jellyfin.enable = true;
                    copyparty.enable = true;
                  };
                };
              };
            };
          }
          ./server.nix
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.tim = {pkgs, ...}: {
                dotfiles = {
                  editor.neovim.enable = true;
                  git.enable = true;
                  shell.nushell.enable = true;
                  shell.zsh.enable = true;
                  shell.tmux.enable = true;
                  gpg.enable = true;
                  gpg-agent.enable = true;
                  gui = {
                    enable = true;
                    niri.enable = true;
                    ghostty.enable = true;
                    firefox.enable = true;
                  };
                };

                home = {
                  packages = with pkgs; [
                    discord
                    prismlauncher # Minecraft client
                  ];
                };
              };
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
          self.homeModules.default
          ./home
          {
            dotfiles = {
              editor.neovim.enable = true;
              git.enable = true;
              shell.nushell.enable = true;
              shell.zsh.enable = true;
              shell.tmux.enable = true;
              gpg.enable = true;
            };
          }
        ];
      };
    };

    homeModules.default = {
      imports = [
        stylix.homeModules.stylix
        nvf.homeManagerModules.default
        ./modules/home
      ];
    };
    nixosModules.default = {
      imports = [
        stylix.nixosModules.stylix
        ./modules/nixos
      ];
      home-manager.sharedModules = [
        nvf.homeManagerModules.default
        ./modules/home
      ];
    };
    darwinModules.default = {
      imports = [
        stylix.darwinModules.stylix
        ./modules/darwin
      ];
      home-manager.sharedModules = [
        nvf.homeManagerModules.default
        ./modules/home
      ];
    };
  };
}
