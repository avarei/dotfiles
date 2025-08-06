{ config, pkgs, lib, inputs, ... }: {

  imports = [
    ./basics.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    kdePackages.dolphin
    xwayland
    xwayland-satellite
    xdg-desktop-portal-gnome
  ];
  programs.alacritty.enable = true;
  programs.fuzzel.enable = true;

  xdg = {
    enable = true;
    configFile."niri/config.kdl".source = ./niri-config.kdl;
    portal.enable = true;
  };


}
