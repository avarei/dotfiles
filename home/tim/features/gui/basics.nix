{ config, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    pavucontrol
    libnotify
    kdePackages.dolphin
  ];

  programs.swayimg = {
    enable = true;
    settings = {
      viewer = {
        window = "#10000010";
        scale = "fill";
      };
      "info.viewer" = {
        top_left = "+name,+format";
      };
      "keys.viewer" = {
        "Shift+r" = "rand_file";
      };
    };
  };
  programs.swaylock = {
    enable = true;

    settings = {
      color = "808080";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };

  services.swayidle = {
    enable = true;

  };

  services.swaync = {
    enable = true;
  };

  services.swww.enable = true;

}
