{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.niri;
in {
  options.dotfiles.gui.niri = {
    enable = lib.mkEnableOption "niri";
  };
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [xwayland-satellite hyprshot];
    programs.fuzzel = {
      enable = true; # app launcher
      settings = {
        border.width = 0;
        main.keyboard-focus = "on-demand";
        main.exit-on-keyboard-focus-loss = true;
      };
    };

    xdg = {
      enable = true;
      configFile."niri/config.kdl".source = ./niri-config.kdl;
      portal.enable = true;
      portal.config = {common = {default = ["gnome"];};};
      portal.extraPortals = with pkgs; [xdg-desktop-portal-gnome];
    };
  };
}
