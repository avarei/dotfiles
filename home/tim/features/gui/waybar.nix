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
        ];
        modules-center = [
          "hyprland/window"
          "wlr/taskbar"
        ];
        modules-right = [
          "mpd"
          "network"
          "bluetooth"
          "pulseaudio"
          "clock"
          "temperature"
        ];
        
        "wlr/taskbar" = {
          tooltip-format = "{title} {app_id}";
        };

        network = {
          interface = "wlo1";
          format = "{ifname}";
          format-wifi = "{essid} ({signalStrength}%)  ";
          format-ethernet = "{ifname}";
          format-disconnected = "x";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
          tooltip-format-ethernet = "{ifname}  ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };

        pulseaudio = {
	        format = "{volume}% {icon}";
	        format-bluetooth = "{volume}% {icon}";
	        format-muted = "";
	        format-icons = {
        		"headphones" = "";
        		"headset" = "󰋎";
            "headset-muted" = "󰋐";
        		"phone" = "";
        		"phone-muted" = "";
        		"portable" = "";
        		"car" = "";
        		"default" = ["" ""];
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
          format-alt = "{:%a, %d.%m. %H:%M}";
        };
      };
    };

  };
}
