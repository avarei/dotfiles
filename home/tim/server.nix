{ config, pkgs, hyprland, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/editor/vscode.nix
    ./features/git
    ./features/zsh
    ./features/gpg
    # ./modules/home/ssh
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

}
