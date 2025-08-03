{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/zsh
    ./features/gpg
    ./features/browser/firefox.nix
    # ./features/gui/hyprland.nix
  ];

}
