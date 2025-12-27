{
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
    dotfiles = {
      url = "github:avarei/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    dotfiles,
    ...
  }: let
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-darwin"];
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    username = "username";
    host = "myhostname";
  in {
    darwinConfigurations = {
      ${host} = nix-darwin.lib.darwinSystem {
        pkgs = pkgsFor.aarch64-darwin;
        modules = [
          dotfiles.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            system.stateVersion = 5;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = {config, ...}: {
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
                  username = lib.mkForce username;
                  homeDirectory = lib.mkForce "/Users/${config.home.username}";
                };
              };
            };
          }
        ];
      };
    };
  };
}
