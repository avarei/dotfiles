{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.gui;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [pavucontrol playerctl];

    stylix.targets.waybar = {
      addCss = false;
      font = "sansSerif";
    };

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [
            "group/left"
          ];
          modules-center = ["group/music"];
          modules-right = [
            "group/privacy"
            "group/tray"
            "group/system"
            "group/misc"
            "group/notification"
          ];

          "group/left" = {
            orientation = "horizontal";
            modules = [
              "custom/apps"
              "wlr/taskbar"
            ];
          };
          "group/music" = {
            orientation = "horizontal";
            modules = [
              "custom/music"
            ];
          };

          "group/privacy" = {
            orientation = "horizontal";
            modules = [
              "privacy"
            ];
          };

          "group/tray" = {
            orientation = "horizontal";
            modules = [
              "tray"
            ];
          };

          "group/system" = {
            orientation = "horizontal";
            modules = [
              "load" # cpu load
              "memory"
            ];
          };

          "group/misc" = {
            orientation = "horizontal";
            modules = [
              "network"
              "bluetooth"
              "pulseaudio"
              "clock"
              "custom/power"
            ];
          };

          "group/notification" = {
            orientation = "horizontal";
            modules = [
              "custom/notification"
            ];
          };

          "wlr/taskbar" = {
            tooltip-format = "{title} {app_id}";
            icon-size = 20;
            sort-by-app-id = true;
            on-click = "activate";
            on-click-middle = "close";
          };

          "custom/music" = {
            format = "󰝚  {}";
            escape = true;
            interval = 5;
            tooltip = false;
            exec = "playerctl metadata --format='{{ title }}'";
            on-click = "playerctl play-pause";
            on-scroll-down = "playerctl next";
            on-scroll-up = "playerctl previous";
            max-length = 50;
          };

          privacy = {icon-size = 16;};

          load = {
            interval = 10;
            format = "  {load1}";
            max-length = 10;
          };
          memory = {
            interval = 10;
            format = "  {}%";
          };

          network = {
            interface = "wlo1";
            format = "{ifname}";
            format-wifi = "󰤨";
            format-ethernet = "  {ifname}";
            format-disconnected = " ";
            tooltip-format = "{ifname}";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
            tooltip-format-ethernet = "{ifname}";
            tooltip-format-disconnected = "Disconnected";
            max-length = 50;
          };
          bluetooth = {
            format-on = "󰂯 ";
            format-connected = "󰂱 ";
            format-connected-battery = "󰂱 {device_battery_percentage}%";
            format-disabled = "󰂲 ";
            format-off = "󰂲 ";
            format-no-controller = "";

            tooltip = true;
            tooltip-format-on = "R-󰳽 Power Off";
            tooltip-format-connected = ''
              Connected Devices: {num_connections}
              R-󰳽 Power Off'';
            tooltip-format-disabled = "L-󰳽 Power On";
            tooltip-format-off = "L-󰳽 Power On";
            on-click = "bluetoothctl power on";
            on-click-right = "bluetoothctl power off";
          };

          pulseaudio = {
            format = "{icon}";
            format-bluetooth = "{icon}";
            format-muted = " ";
            format-icons = {
              "headphones" = " ";
              "headset" = "󰋎 ";
              "headset-muted" = "󰋐 ";
              "phone" = " ";
              "phone-muted" = " ";
              "portable" = " ";
              "car" = " ";
              "default" = [" " " " "  "];
            };
            scroll-step = 1;
            on-click = "pavucontrol";
          };

          clock = {
            format = "  {:%H:%M}";
            tooltip-format = "󰃭  {:%d.%m.%Y}";
          };

          tray = {
            icon-size = 21;
            spacing = 10;
            show-passive-items = true;
          };

          "custom/power" = {
            tooltip = false;
            format = " 󰐥 ";
            menu = "on-click";
            menu-file = ./waybar-power-menu.xml;
            menu-actions = {
              lock = "hyprlock";
              logout = "niri msg action quit --skip-confirmation";
              shutdown = "shutdown -h now";
              reboot = "reboot";
            };
            # TODO: should be fixed in versions of waybar after 0.14.0 # https://github.com/Alexays/Waybar/issues/4510
            # currently waybar crashes without this on scroll

            on-scroll-down = "true";
            on-scroll-up = "true";
          };

          "custom/apps" = {
            tooltip = false;
            format = "  ";
            on-click = "fuzzel";
            on-scroll-down = "true";
            on-scroll-up = "true";
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "  <span foreground='red'><sup></sup></span>";
              none = "  ";
              dnd-notification = "  <span foreground='red'><sup></sup></span>";
              dnd-none = "  ";
              inhibited-notification = "  <span foreground='red'><sup></sup></span>";
              inhibited-none = "  ";
              dnd-inhibited-notification = "  <span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "  ";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
            on-scroll-down = "true";
            on-scroll-up = "true";
          };
        };
      };
      style = lib.mkAfter ''
        * {
          font-size: 17px;
          min-height: 0;
          margin: 0px;
        }


        #waybar {
          background-color: transparent;
          color: @base05;
          margin: 5px;
        }

        window#waybar > box {
          margin-top: 5px;
          margin-bottom: 5px;
        }

        window box box widget box {
          background-color: @base02;
          border-radius: 1rem;
          margin-left: 0.5rem;
          margin-right: 0.5rem;
          padding: 0px;
        }
        window box box widget box widget label {
          padding-left: 0.25rem;
          padding-right: 0.25rem;
          margin-left: 0.25rem;
          margin-right: 0.25rem;
        }

        #taskbar {
          color: @base07;
        }

        #taskbar button {
          color: @base07;
          border-radius: 1rem;
          padding-left: 0.5rem;
          padding-right: 0.5rem;
          transition: all 0.2s ease-in-out;
        }

        #taskbar button:active {
          color: @base0D;
          background-image: linear-gradient(135deg, @base0F, @base0D);
        }

        #taskbar button:hover {
          color: @base0C;
          background-image: linear-gradient(135deg, @base0F, @base0D);
        }

        #taskbar button.active {
          background-image: linear-gradient(@base0F, @base0D);
        }
        #taskbar button.fullscreen {
          background-image: linear-gradient(@base08, @base0F);
        }

        #network {
          color: @base0E;
        }

        #custom-apps {
          font-size: 24px;
          color: @base0E;
          padding-right: 0.5rem;
          border-radius: 1rem;
          transition: all 0.2s ease-in-out;
        }
        #custom-apps:hover {
          color: @base02;
          background-image: linear-gradient(135deg, @base0F, @base08);
        }

        #bluetooth {
          color: @base07;
        }

        #clock,
        #load,
        #memory{
          color: @base0D;
        }

        #custom-power {
          color: @base0A;
          border-radius: 1rem;
          transition: all 0.2s ease-in-out;
        }
        #custom-power:hover {
          color: @base02;
          background-image: linear-gradient(135deg, @base0A, @base09);
        }

        #pulseaudio {
          color: @base08;
        }

        #custom-notification {
          color: @base07;
          border-radius: 1rem 1rem 1rem 1rem;
          margin-left: 0.5rem;
          margin-right: 0.5rem;
          transition: all 0.2s ease-in-out;
        }
        #custom-notification:hover {
          color: @base02;
          background-image: linear-gradient(135deg, @base07, @base06);
        }

        #custom-music {
          color: @base0E;
          border-radius: 1rem;
        }

        #custom-lock {
          color: @base07;
        }

        #tray {
          margin-right: 0.5rem;
          border-radius: 1rem;
        }

        #privacy {
          border-radius: 1rem;
        }

        tooltip {
          border-radius: 1rem;
          background-color: @base04;
        }

        menu {
          background-color: @base03;
          color: @base05;
          border-radius: 1rem;
          border-width: 8px;
        }

        menuitem:hover {
          border-radius: 1rem 1rem 1rem 1rem;
          background-color: @base04;
        }
      '';
    };
  };
}
