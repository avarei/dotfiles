{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.hyprland;
  mod = "SUPER";
in {
  options.dotfiles.gui.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [grim slurp hyprshot];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      xwayland.enable = true;

      settings = {
        "$mod" = mod;

        exec-once = [
          "uwsm app -- dms run"
        ];

        env = [
          "HYPRCURSOR_THEME,catppuccin-mocha-dark-cursors"
          "HYPRCURSOR_SIZE,20"
          "XCURSOR_THEME,catppuccin-mocha-dark-cursors"
          "XCURSOR_SIZE,20"
        ];

        monitor = [
          "DP-3,3440x1440@99.982,auto,1,vrr,1"
          ",preferred,auto,1"
        ];

        input = {
          kb_layout = "us";
          kb_variant = "intl";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            tap-to-click = true;
          };
        };

        general = {
          gaps_in = 8;
          gaps_out = 8;
          border_size = 2;
          layout = "dwindle";
        };

        decoration = {
          rounding = 12;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        bind = [
          # --- App launching ---
          "$mod, T, exec, ghostty"
          "$mod, F, exec, firefox"
          "$mod, SPACE, exec, dms ipc spotlight toggle"
          "$mod, N, exec, dms ipc notifications toggle"
          "$mod, comma, exec, dms ipc settings toggle"
          "$mod, P, exec, dms ipc notepad toggle"
          "$mod, V, exec, dms ipc clipboard toggle"
          "$mod, X, exec, dms ipc powermenu toggle"
          "$mod, M, exec, dms ipc processlist toggle"
          "SUPER ALT, L, exec, dms ipc lock lock"

          # --- Session ---
          "$mod SHIFT, P, dpms, off"
          "$mod SHIFT, E, exit,"
          "CTRL ALT, Delete, exit,"

          # --- Window management ---
          "$mod, Q, killactive,"
          "$mod SHIFT, F, fullscreen, 0"
          "$mod SHIFT, V, togglefloating,"

          # --- Screenshots ---
          ", Print, exec, hyprshot -m output"
          "CTRL, Print, exec, hyprshot -m output"
          "ALT, Print, exec, hyprshot -m window"
          "$mod, Z, exec, hyprshot --freeze -m region --clipboard-only"

          # --- Focus navigation ---
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, A, movefocus, l"
          "$mod, D, movefocus, r"
          "$mod, W, movefocus, u"
          "$mod, S, movefocus, d"

          # --- Move windows ---
          "$mod CTRL, left, movewindow, l"
          "$mod CTRL, right, movewindow, r"
          "$mod CTRL, up, movewindow, u"
          "$mod CTRL, down, movewindow, d"
          "$mod CTRL, A, movewindow, l"
          "$mod CTRL, D, movewindow, r"
          "$mod CTRL, W, movewindow, u"
          "$mod CTRL, S, movewindow, d"

          # --- Workspaces ---
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod CTRL, 1, movetoworkspace, 1"
          "$mod CTRL, 2, movetoworkspace, 2"
          "$mod CTRL, 3, movetoworkspace, 3"
          "$mod CTRL, 4, movetoworkspace, 4"
          "$mod CTRL, 5, movetoworkspace, 5"
          "$mod CTRL, 6, movetoworkspace, 6"
          "$mod CTRL, 7, movetoworkspace, 7"
          "$mod CTRL, 8, movetoworkspace, 8"
          "$mod CTRL, 9, movetoworkspace, 9"
          "$mod, U, workspace, e-1"
          "$mod, I, workspace, e+1"
          "$mod CTRL, U, movetoworkspace, e-1"
          "$mod CTRL, I, movetoworkspace, e+1"
        ];

        bindl = [
          # --- Media / brightness ---
          ", XF86AudioRaiseVolume, exec, dms ipc audio increment 3"
          ", XF86AudioLowerVolume, exec, dms ipc audio decrement 3"
          ", XF86AudioMute, exec, dms ipc audio mute"
          ", XF86AudioMicMute, exec, dms ipc audio micmute"
          ", XF86MonBrightnessUp, exec, dms ipc brightness increment 5 \"\""
          ", XF86MonBrightnessDown, exec, dms ipc brightness decrement 5 \"\""
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
