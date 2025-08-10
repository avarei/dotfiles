{ config, pkgs, lib, inputs, ... }: {

  imports = [
    ./basics.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    xwayland-satellite
  ];
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      background-opacity = 0.75;
    };
  };
  programs.fuzzel = {
    enable = true; # app launcher
    settings = {
      font.name = "Ubuntu Nerd Font";
      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "94e2d5ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "94e2d5ff";
        counter = "7f849cff";
        border = "94e2d5ff";
      };
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
