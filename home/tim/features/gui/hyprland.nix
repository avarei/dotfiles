{ config, pkgs, lib, inputs, ... }: {

  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    kitty
    kdePackages.dolphin
    wofi
    xwayland-satellite
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with pkgs.hyprlandPlugins; [
      # borders-plus-plus
    ];

    settings = {

      exec-once = [
        "waybar"
        "firefox"
        "xwayland-satellite"
      ];

      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        "$mod, Q, exec, kitty"
        "$mod, SPACE, exec, $menu"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, M, exit,"
        "$mod, C, killactive,"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"


        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
      ];
      binds = {
        drag_threshold = 10;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindc = [
        "$mod, mouse:272, togglefloating"
      ];

      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

    };
    
  };
}
