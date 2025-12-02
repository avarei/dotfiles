{ config, pkgs, lib, inputs, ... }: {

  home.packages = with pkgs; [
    pavucontrol
    playerctl
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
          "custom/music"
        ];
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

        privacy = {
          icon-size = 16;
        };

        load = {
          interval = 10;
          format = " {load1}";
          max-length = 10;
        };
        memory = {
          interval = 10;
          format = " {}%";
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
