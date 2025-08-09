{ config, pkgs, lib, inputs, ... }: {

  imports = [
    ./basics.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
  ];
  programs.alacritty.enable = true; # terminal
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      background-opacity = 0.75;
    };
  };
  programs.fuzzel.enable = true; # app launcher

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
