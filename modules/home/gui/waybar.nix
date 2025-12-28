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
            "custom/apps"
            "wlr/taskbar"
          ];
          modules-center = ["custom/music"];
          modules-right = [
            "tray"
            "privacy"
            "load" # cpu load
            "memory"
            "network"
            "bluetooth"
            "pulseaudio"
            "clock"
            "custom/power"
            "custom/notification"
          ];

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
            format = "󰐥 ";
            menu = "on-click";
            menu-file = ./waybar-power-menu.xml;
            menu-actions = {
              lock = "hyprlock";
              logout = "niri msg action quit --skip-confirmation";
              shutdown = "shutdown -h now";
              reboot = "reboot";
            };
          };

          "custom/apps" = {
            tooltip = false;
            format = "󰵆 ";
            on-click = "fuzzel";
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = " <span foreground='red'><sup></sup></span>";
              none = " ";
              dnd-notification = " <span foreground='red'><sup></sup></span>";
              dnd-none = " ";
              inhibited-notification = " <span foreground='red'><sup></sup></span>";
              inhibited-none = " ";
              dnd-inhibited-notification = " <span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = " ";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
        };
      };
      style = lib.mkAfter ''
        * {
          font-size: 17px;
          min-height: 0;
        }


        #waybar {
          background-color: transparent;
          color: @base05;
          margin: 5px;
        }

        /* section */
        #custom-music,
        #tray,
        #clock,
        #battery,
        #pulseaudio,
        #network,
        #bluetooth,
        #privacy,
        #taskbar,
        #custom-notification,
        #custom-lock,
        #custom-power,
        #custom-apps,
        #load,
        #memory {
          background-color: @base02;
          padding-left: 1rem;
          padding-right: 1rem;
          margin: 5px 0;
        }

        /* section start */
        #network,
        #custom-apps,
        #load {
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 0.5rem;
        }

        /* section end */
        #custom-power,
        #memory {
          border-radius: 0px 1rem 1rem 0px;
          margin-right: 0.5rem;
        }

        #taskbar {
          color: @base07;
          border-radius: 0px 1rem 1rem 0px;
          padding-left: 0.5rem;
          margin-right: 0.5rem;
        }

        #taskbar button {
          color: @base07;
          border-radius: 1rem;
          padding-left: 1rem;
          padding-right: 1rem;
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
          color: @base0E;
          padding-right: 0.5rem;
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
        }

        #pulseaudio {
          color: @base08;
        }

        #custom-notification {
          color: @base07;
          border-radius: 1rem 1rem 1rem 1rem;
          margin-left: 0.5rem;
          margin-right: 0.5rem;
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
