{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui;
in {
  imports = [
    ./niri.nix
    ./ghostty.nix
    ./firefox.nix
    ./dank-material-shell.nix
  ];
  options.dotfiles.gui = {
    enable = lib.mkEnableOption "gui";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pavucontrol # audio in/out
      libnotify
      nautilus # filebrowser
      wl-clipboard-rs
      gparted # partition management
    ];

    home.pointerCursor = {
      enable = true;
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 10;
      sway.enable = true;
    };

    programs.swayimg = {
      enable = true;
      settings = {
        viewer = {
          window = "#10000010";
          scale = "fill";
        };
        "info.viewer" = {
          top_left = "+name,+format";
        };
        "keys.viewer" = {
          "Shift+r" = "rand_file";
        };
      };
    };

    services.swww.enable = true;
  };
}
