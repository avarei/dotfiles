{ config, pkgs, lib, inputs, ... }: {

  home.packages = with pkgs; [
    pavucontrol
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "wlr/taskbar"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "privacy"
          "network"
          "bluetooth"
          "pulseaudio"
          "clock"
          "custom/notification"
        ];
        
        "wlr/taskbar" = {
          tooltip-format = "{title} {app_id}";
          icon-size = 20;
          sort-by-app-id = true;
          on-click = "activate";
          on-click-middle = "close";
        };

        privacy = {
          icon-size = 16;
        };

        network = {
          interface = "wlo1";
          format = "{ifname}";
          format-wifi = "󰤨";
          format-ethernet = " {ifname}";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };
        bluetooth = {
          format-on = "󰂯";
          format-connected = "󰂱";
          format-connected-battery = "󰂱 {device_battery_percentage}%";
          format-disabled = "󰂲";
          format-off = "󰂲";

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
	        format-muted = "";
	        format-icons = {
        		"headphones" = "";
        		"headset" = "󰋎";
            "headset-muted" = "󰋐";
        		"phone" = "";
        		"phone-muted" = "";
        		"portable" = "";
        		"car" = "";
        		"default" = ["" "" " "];
          };
      	  scroll-step = 1;
        	on-click = "pavucontrol";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = true;
          format = "{name}: {icon}";
          format-icons = {
            urgent = "!";
            active = "";
            default = "";
          };
        };
        clock = {
          format = "  {:%H:%M}";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
          show-passive-items = true;
        };

        "custom/music" = {
          format = "  {}";
          escape = true;
          interval = 5;
          tooltip = false;
          exec = "playerctl metadata --format='{{ title }}'";
          on-click = "playerctl play-pause";
          max-length = 50;
        };


        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
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
    style = ./waybar-style.css;
  };

}
