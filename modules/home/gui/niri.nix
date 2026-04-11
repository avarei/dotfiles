{
  config,
  pkgs,
  lib,
  dgop,
  ...
}: let
  cfg = config.dotfiles.gui.niri;
in {
  options.dotfiles.gui.niri = {
    enable = lib.mkEnableOption "niri";
  };
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [xwayland-satellite hyprshot];

    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      dgop.package = dgop.packages.${pkgs.system}.default;
      niri = {
        enableSpawn = true;
        enableKeybinds = true;
        includes.enable = false; # dms/*.kdl files are runtime-generated, not present on first boot
      };
    };

    programs.niri = {
      settings = {
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

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        hotkey-overlay = {};
        animations = {};

        binds = {
          # --- App launching ---
          "Mod+T" = {
            action.spawn = ["ghostty"];
            hotkey-overlay.title = "Open Terminal";
          };
          "Mod+F" = {
            action.spawn = ["firefox"];
            hotkey-overlay.title = "Open Browser";
          };

          # --- Session ---
          "Super+L" = {
            action.spawn = ["dms" "ipc" "lock" "lock"];
            hotkey-overlay.title = "Lock Screen";
          };

          # --- System actions ---
          "Mod+Shift+Slash".action.show-hotkey-overlay = [];
          "Mod+Q" = {
            action.close-window = [];
            repeat = false;
          };
          "Mod+O" = {
            action.toggle-overview = [];
            repeat = false;
          };
          "Mod+Shift+E".action.quit = [];
          "Ctrl+Alt+Delete".action.quit = [];
          "Mod+Shift+P".action.power-off-monitors = [];
          "Mod+Escape" = {
            action.toggle-keyboard-shortcuts-inhibit = [];
            allow-inhibiting = false;
          };

          # --- Screenshots ---
          "Print".action.screenshot = [];
          "Ctrl+Print".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];
          "Mod+Z".action.spawn = ["hyprshot" "--freeze" "-m" "region" "--clipboard-only"];

          # --- Cast window ---
          "Mod+B".action.spawn = ["sh" "-c" "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)"];

          # --- Focus navigation ---
          "Mod+Left".action.focus-column-left = [];
          "Mod+Right".action.focus-column-right = [];
          "Mod+Up".action.focus-window-up = [];
          "Mod+Down".action.focus-window-down = [];
          "Mod+A".action.focus-column-left = [];
          "Mod+S".action.focus-window-down = [];
          "Mod+W".action.focus-window-up = [];
          "Mod+D".action.focus-column-right = [];

          # --- Move navigation ---
          "Mod+Ctrl+Left".action.move-column-left = [];
          "Mod+Ctrl+Right".action.move-column-right = [];
          "Mod+Ctrl+Up".action.move-window-up = [];
          "Mod+Ctrl+Down".action.move-window-down = [];
          "Mod+Ctrl+A".action.move-column-left = [];
          "Mod+Ctrl+S".action.move-window-down = [];
          "Mod+Ctrl+W".action.move-window-up = [];
          "Mod+Ctrl+D".action.move-column-right = [];

          # --- Workspaces ---
          "Mod+U".action.focus-workspace-down = [];
          "Mod+I".action.focus-workspace-up = [];
          "Mod+Ctrl+U".action.move-column-to-workspace-down = [];
          "Mod+Ctrl+I".action.move-column-to-workspace-up = [];
          "Mod+Shift+U".action.move-workspace-down = [];
          "Mod+Shift+I".action.move-workspace-up = [];
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;
          "Mod+Home".action.focus-column-first = [];
          "Mod+End".action.focus-column-last = [];
          "Mod+Ctrl+Home".action.move-column-to-first = [];
          "Mod+Ctrl+End".action.move-column-to-last = [];

          # --- Mouse wheel navigation ---
          "Mod+WheelScrollRight".action.focus-column-right = [];
          "Mod+WheelScrollLeft".action.focus-column-left = [];
          "Mod+WheelScrollDown".action.focus-column-right = [];
          "Mod+WheelScrollUp".action.focus-column-left = [];
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = [];
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [];
          "Mod+Ctrl+WheelScrollDown".action.move-column-right = [];
          "Mod+Ctrl+WheelScrollUp".action.move-column-left = [];
          "Mod+Shift+WheelScrollDown" = {
            action.focus-workspace-down = [];
            cooldown-ms = 150;
          };
          "Mod+Shift+WheelScrollUp" = {
            action.focus-workspace-up = [];
            cooldown-ms = 150;
          };
          "Mod+Ctrl+Shift+WheelScrollDown" = {
            action.move-column-to-workspace-down = [];
            cooldown-ms = 150;
          };
          "Mod+Ctrl+Shift+WheelScrollUp" = {
            action.move-column-to-workspace-up = [];
            cooldown-ms = 150;
          };

          # --- Sizing and layout ---
          "Mod+R".action.switch-preset-column-width = [];
          "Mod+Shift+R".action.switch-preset-window-height = [];
          "Mod+Ctrl+R".action.reset-window-height = [];
          "Mod+Shift+F".action.maximize-column = [];
          "Mod+Ctrl+F".action.fullscreen-window = [];
          "Mod+C".action.center-column = [];
          "Mod+Ctrl+C".action.center-visible-columns = [];
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          # --- Column tiling ---
          "Mod+BracketLeft".action.consume-or-expel-window-left = [];
          "Mod+BracketRight".action.consume-or-expel-window-right = [];
          "Mod+Period".action.expel-window-from-column = [];

          # --- Floating ---
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];
        };

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
          {
            geometry-corner-radius = let
              r = 12.0;
            in {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
            clip-to-geometry = true;
          }
        ];
      };
    };
  };
}
