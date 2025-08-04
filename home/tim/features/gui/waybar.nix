{ config, pkgs, lib, inputs, ... }: {

  home.packages = with pkgs; [

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
        ];
        modules-right = [
          "mpd"
          "network"
          "bluetooth"
          "pulseaudio"
          "clock"
          "temperature"
        ];

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
