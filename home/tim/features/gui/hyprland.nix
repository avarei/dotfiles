{ config, pkgs, lib, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [ "$mod, F, exec, firefox" ];
    };
  };
}
