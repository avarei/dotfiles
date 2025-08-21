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

      input = {
        kb_layout = "us(intl)";
        numlock_by_default = true;
      };

      exec-once = [
        "waybar"
        "firefox"
        "xwayland-satellite"
      ];

      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        "$mod, T, exec, ghostty"
        "$mod, SPACE, exec, $menu"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod CTRL, F, fullscreen, 0"
        "$mod, M, exit,"
        "$mod, Q, killactive,"

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, a, movefocus, l"
        "$mod, d, movefocus, r"
        "$mod, w, movefocus, u"
        "$mod, s, movefocus, d"

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

        # Move active active window
        "$mod CTRL, left, swapwindow, l"
        "$mod CTRL, right, swapwindow, r"
        "$mod CTRL, up, swapwindow, u"
        "$mod CTRL, down, swapwindow, d"

        "$mod CTRL, a, swapwindow, l"
        "$mod CTRL, d, swapwindow, r"
        "$mod CTRL, w, swapwindow, u"
        "$mod CTRL, s, swapwindow, d"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod CTRL, 1, movetoworkspace, 1"
        "$mod CTRL, 2, movetoworkspace, 2"
        "$mod CTRL, 3, movetoworkspace, 3"
        "$mod CTRL, 4, movetoworkspace, 4"
        "$mod CTRL, 5, movetoworkspace, 5"
        "$mod CTRL, 6, movetoworkspace, 6"
        "$mod CTRL, 7, movetoworkspace, 7"
        "$mod CTRL, 8, movetoworkspace, 8"
        "$mod CTRL, 9, movetoworkspace, 9"
        "$mod CTRL, 0, movetoworkspace, 10"
      ];
      binds = {
        drag_threshold = 20;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindc = [
        "$mod, mouse:272, togglefloating"
      ];

      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$menu" = "fuzzel";

      decoration = {
        rounding = 20;
        rounding_power = 4.0;
      };

      windowrule = [
        "float, class:firefox$, title:Picture-in-Picture"
      ];
    };
  };
}
