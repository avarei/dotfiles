{ config, pkgs, lib, ... }:

{
  imports = [
    ../features/editor/neovim.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "tim";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    jq
    yq
    nerd-fonts.ubuntu-mono
    tree
  ];
  fonts.fontconfig.enable = true;
}
