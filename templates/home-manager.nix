{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:avarei/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    home-manager,
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
  in {
    homeConfigurations = {
      "username@host" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          dotfiles.homeModules.default
          {
            home.username = lib.mkForce "username";
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
  };
}
