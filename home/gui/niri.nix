{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./basics.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    hyprshot
  ];
  programs.fuzzel = {
    enable = true; # app launcher
    settings = {
      border.width = 0;
    };
  };

  xdg = {
    enable = true;
    configFile."niri/config.kdl".source = ./niri-config.kdl;
    portal.enable = true;
    portal.config = {
      common = {
        default = ["gnome"];
      };
    };
    portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };
}
