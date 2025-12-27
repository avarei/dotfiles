{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
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
    host = "myhost";
  in {
    nixosConfigurations = {
      ${host} = nixpkgs.lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          dotfiles.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = {pkgs, ...}: {
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
                  username = lib.mkForce username;
                  packages = with pkgs; [
                    discord
                    prismlauncher # Minecraft client
                  ];
                };
              };
            };
          }
          ./hosts/${username}.nix
        ];
      };
    };
  };
}
