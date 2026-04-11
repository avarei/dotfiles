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

    programs.niri.settings = {
      input = {
        keyboard = {
          xkb.layout = "us(intl)";
          numlock = true;
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse = {};
        trackpoint = {};
        warp-mouse-to-focus.enable = true;
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "70%";
        };
      };

      layout = {
        gaps = 16;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];
        default-column-width = {proportion = 0.5;};
        focus-ring = {
          width = 4;
          inactive.color = "#505050";
          active.gradient = {
            from = "#cba6f7";
            to = "#94e2d5";
            angle = 45;
          };
        };
        border = {
          enable = false;
          width = 4;
          active.color = "#ffc87f";
          inactive.color = "#505050";
          urgent.color = "#9b0000";
        };
        shadow = {
          enable = true;
          softness = 7;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          color = "#181825a0";
        };
        struts = {
          top = -10;
        };
      };

      cursor = {
        theme = "catppuccin-mocha-dark-cursors";
        size = 20;
      };

      spawn-at-startup = [
        {command = ["xwayland-satellite" ":50"];}
      ];

      environment = {
        DISPLAY = ":50";
      };

      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      hotkey-overlay = {};
      animations = {};

      window-rules = [
        {
          matches = [{app-id = "com.mitchellh.ghostty";}];
          default-column-width = {proportion = 0.20;};
        }
        {
          matches = [{app-id = "PureRef";}];
          draw-border-with-background = false;
        }
        {
          matches = [{app-id = "^org\\.wezfurlong\\.wezterm$";}];
          default-column-width = {};
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          matches = [{app-id = "steam";}];
          excludes = [
            {title = "^Steam$";}
            {title = "^Steam - Browser$";}
          ];
          default-column-width = {proportion = 0.10;};
        }
        {
          matches = [{app-id = "^steam_app_.+$";}];
          open-fullscreen = true;
        }
        {
          matches = [{is-window-cast-target = true;}];
          focus-ring = {
            enable = false;
          };
          border = {
            enable = true;
            width = 4;
            active.gradient = {
              from = "#fab387";
              to = "#f38ba8";
              angle = 45;
            };
            inactive.gradient = {
              from = "#f38ba8";
              to = "#f5c2e7";
              angle = 45;
            };
          };
        }
      ];

      binds = {
        "Mod+T" = {
          action.spawn = ["ghostty"];
          hotkey-overlay.title = "Open Terminal: ghostty";
        };
        "Mod+E" = {
          action.spawn = ["nautilus"];
          hotkey-overlay.title = "Open Explorer: nautilus";
        };
        "Mod+F" = {
          action.spawn = ["firefox"];
          hotkey-overlay.title = "Open Browser: firefox";
        };
        "Mod+B".action.spawn = ["sh" "-c" "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)"];
      };
    };

    xdg = {
      enable = true;
      portal.enable = true;
      portal.config = {common = {default = ["gnome"];};};
      portal.extraPortals = with pkgs; [xdg-desktop-portal-gnome];
    };
  };
}
