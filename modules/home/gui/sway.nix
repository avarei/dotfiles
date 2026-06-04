{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.sway;
  mod = "Mod4";
in {
  options.dotfiles.gui.sway = {
    enable = lib.mkEnableOption "sway";
  };
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [grim slurp];

    wayland.windowManager.sway = {
      enable = true;
      xwayland = true;
      # NVIDIA proprietary/open kernel modules — sway refuses to start without this.
      # The home-manager wrapper at ~/.nix-profile/bin/sway shadows the NixOS one in PATH,
      # so the flag has to be set here too (not only in the NixOS programs.sway module).
      extraOptions = ["--unsupported-gpu"];
      config = {
        modifier = mod;
        terminal = "ghostty";
        bars = [];

        input = {
          "type:keyboard" = {
            xkb_layout = "us(intl)";
            xkb_numlock = "enabled";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
        };

        seat."*".xcursor_theme = lib.mkForce "catppuccin-mocha-dark-cursors 20";

        output."DP-3" = {
          mode = "3440x1440@99.982Hz";
          adaptive_sync = "on";
        };

        startup = [
          {command = "dms run";}
        ];

        keybindings = lib.mkOptionDefault {
          # --- App launching ---
          "${mod}+t" = "exec ghostty";
          "${mod}+f" = "exec firefox";
          "${mod}+space" = "exec dms ipc spotlight toggle";
          "${mod}+n" = "exec dms ipc notifications toggle";
          "${mod}+comma" = "exec dms ipc settings toggle";
          "${mod}+p" = "exec dms ipc notepad toggle";
          "${mod}+v" = "exec dms ipc clipboard toggle";
          "${mod}+x" = "exec dms ipc powermenu toggle";
          "${mod}+m" = "exec dms ipc processlist toggle";
          "Super_L+Alt+l" = "exec dms ipc lock lock";

          # --- Media / brightness ---
          "XF86AudioRaiseVolume" = "exec dms ipc audio increment 3";
          "XF86AudioLowerVolume" = "exec dms ipc audio decrement 3";
          "XF86AudioMute" = "exec dms ipc audio mute";
          "XF86AudioMicMute" = "exec dms ipc audio micmute";
          "XF86MonBrightnessUp" = "exec dms ipc brightness increment 5 \"\"";
          "XF86MonBrightnessDown" = "exec dms ipc brightness decrement 5 \"\"";

          # --- Session ---
          "${mod}+shift+p" = "output * dpms off";

          # --- Window management ---
          "${mod}+q" = "kill";
          "${mod}+shift+f" = "fullscreen toggle";
          "${mod}+shift+v" = "floating toggle";

          # --- Screenshots ---
          "${mod}+z" = "exec grim -g \"$(slurp)\" - | wl-copy";

          # --- Workspaces ---
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+ctrl+1" = "move container to workspace number 1";
          "${mod}+ctrl+2" = "move container to workspace number 2";
          "${mod}+ctrl+3" = "move container to workspace number 3";
          "${mod}+ctrl+4" = "move container to workspace number 4";
          "${mod}+ctrl+5" = "move container to workspace number 5";
          "${mod}+ctrl+6" = "move container to workspace number 6";
          "${mod}+ctrl+7" = "move container to workspace number 7";
          "${mod}+ctrl+8" = "move container to workspace number 8";
          "${mod}+ctrl+9" = "move container to workspace number 9";
          "${mod}+u" = "workspace prev";
          "${mod}+i" = "workspace next";
          "${mod}+ctrl+u" = "move container to workspace prev";
          "${mod}+ctrl+i" = "move container to workspace next";

          # --- Sizing ---
          "${mod}+r" = "mode resize";
        };

        window = {
          border = 2;
          titlebar = false;
          commands = [
            {
              criteria.app_id = "^steam_app_.+$";
              command = "fullscreen enable";
            }
            {
              criteria = {
                app_id = "firefox";
                title = "^Picture-in-Picture$";
              };
              command = "floating enable";
            }
          ];
        };

        gaps = {
          inner = 8;
          outer = 8;
        };
      };
    };
  };
}
