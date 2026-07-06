{
  description = "My Config and Dotfiles for macOS and NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    stylix,
    nvf,
    niri,
    dms,
    dgop,
    ...
  }: let
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-darwin"];
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
    pkgsUnstableFor = lib.genAttrs systems (
      system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }
    );
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
              extraSpecialArgs = {
                pkgs-unstable = pkgsUnstableFor.aarch64-darwin;
              };
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
        specialArgs = {
          pkgs-unstable = pkgsUnstableFor.x86_64-linux;
        };
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            dotfiles.selfhosted.immich.enable = true;
            dotfiles.gaming.factorio-server.enable = true;
            dotfiles.gaming.moonlight.enable = true;
            dotfiles.gui.plasma.enable = true;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                pkgs-unstable = pkgsUnstableFor.x86_64-linux;
              };
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
                  gui = {
                    enable = true;
                    ghostty.enable = true;
                    firefox.enable = true;
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
        specialArgs = {
          pkgs-unstable = pkgsUnstableFor.x86_64-linux;
        };
        modules = [
          self.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            dotfiles = {
              gui.niri.enable = true;
              gui.sway.enable = true;
              gui.hyprland.enable = true;
              gui.plasma.enable = true;
              gaming.steam.enable = true;
              gaming.sunshine.enable = true;
              selfhosted.ollama.enable = true;
              virtualisation.podman.enable = true;
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                pkgs-unstable = pkgsUnstableFor.x86_64-linux;
              };
              users.tim = {pkgs, ...}: {
                dotfiles = {
                  editor.neovim = {
                    enable = true;
                    minuet-ai.enable = true;
                  };
                  editor.opencode.enable = true;
                  editor.aider = {
                    enable = true;
                    ollama.enable = true;
                  };
                  git.enable = true;
                  shell.nushell.enable = true;
                  shell.zsh.enable = true;
                  shell.tmux.enable = true;
                  gpg.enable = true;
                  gpg-agent.enable = true;
                  gui = {
                    enable = true;
                    niri.enable = true;
                    sway.enable = true;
                    hyprland.enable = true;
                    ghostty.enable = true;
                    firefox.enable = true;
                  };
                };

                home = {
                  packages = with pkgs; [
                    vesktop
                    vscodium
                    prismlauncher # Minecraft client
                    archipelago
                    poptracker
                  ];
                };
              };
            };
          }
          ./hosts/desktop.nix
        ];
      };
    };

    homeConfigurations = {
      "tim@work" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          pkgs-unstable = pkgsUnstableFor.x86_64-linux;
        };
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
        niri.nixosModules.niri
        dms.nixosModules.dank-material-shell
        dms.nixosModules.greeter
        ./modules/nixos
      ];
      home-manager.extraSpecialArgs = {inherit dgop;};
      home-manager.sharedModules = [
        nvf.homeManagerModules.default
        dms.homeModules.dank-material-shell
        dms.homeModules.niri
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
