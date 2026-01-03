{
  description = "My Config and Dotfiles for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
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
    niri.url = "github:sodiboo/niri-flake";
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
                  kubernetes.cli.enable = true;
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
          ./hosts/server.nix
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            dotfiles = {
              gui.niri.enable = true;
              gaming.steam.enable = true;
            };
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
                    archipelago
                    poptracker
                  ];
                };
              };
            };
          }
          {
            nixpkgs.overlays = [niri.overlays.niri];
          }
          ./hosts/desktop.nix
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
    templates = {
      home-manager = {
        path = ./templates/home-manager;
        description = "For Systems whihc are using home-manager but not nixos or darwin";
        welcomeText = ''
          This is a template using my personal dotfiles. Please consider all options very unstable. They may change without notice.
          to get started replace the username and host in the flake with yours.

          run `home-manager switch --flake .#username@hostname` to switch to your new configuration.
        '';
      };
      nixos = {
        path = ./templates/nixos;
        description = "For NixOS based Systems";
        welcomeText = ''
          This is a template using my personal dotfiles. Please consider all options very unstable. They may change without notice.
          to get started replace the username and host in the flake with yours.

          - run `sudo nixos-rebuild test --flake .#yourhostname` to test your condifuration.
          - run `sudo nixos-rebuild switch --flake .#yourhostname` to switch to it.
        '';
      };
      darwin = {
        path = ./templates/darwin;
        description = "For Darwin based Systems (MacOS)";
        welcomeText = ''
          This is a template using my personal dotfiles. Please consider all options very unstable. They may change without notice.
          to get started replace the username and host in the flake with yours.

          add your `hardware-configuration.nix` and reference it in the flake. by default ./hosts/$\{username\}.nix is referenced.

          run `sudo darwin-rebuild switch --flake .#yourhostname` to switch to your configuration.
        '';
      };
    };
  };
}
