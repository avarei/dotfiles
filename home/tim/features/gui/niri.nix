{ config, pkgs, lib, inputs, ... }: {

  imports = [
    ./basics.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    kdePackages.dolphin
    xwayland
    xwayland-satellite
  ];
  programs.alacritty.enable = true;
  programs.fuzzel.enable = true;


  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

}
