{ config, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    pavucontrol
    libnotify
    nautilus
    wl-clipboard-rs
  ];

  home.pointerCursor = {
    enable = true;
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 10;
    sway.enable = true;
  };

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

  # requires security.services.swaylock in hosts
  programs.swaylock = {
    enable = true;

    settings = {
      ignore-empty-password = true;

      color = "1d1f21";
      indicator-idle-visible = true;
      indicator-radius = 150;
      indicator-thickness = 30;

      inside-color = "1d1f21";
      inside-clear-color = "1d1f21";
      inside-ver-color = "1d1f21";
      inside-wrong-color = "1d1f21";

      key-hl-color = "7aa6daaa";
      bs-hl-color = "d54e53aa";

      separator-color = "55555555";

      line-color = "1d1f21";
      line-uses-ring = true;

      text-color = "81a2be";
      text-clear-color = "b5bd68";
      text-caps-lock-color = "f0c674";
      text-ver-color = "81a2be";
      text-wrong-color = "cc6666";

      ring-color = "81a2be55";
      ring-ver-color = "81a2be";
      ring-clear-color = "b5bd6811";
      ring-wrong-color = "cc6666";
    };
  };

  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = (4 * 60); # in seconds
          command = "${pkgs.libnotify}/bin/notify-send 'Going to Sleep in 1 minute' -t 60000";
        }
        {
          timeout = (5 * 60);
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = (5 * 60) + 5;
          command = lock;
        }
        # {
        #   timeout = 30;
        #   command = "${pkgs.systemd}/bin/systemctl suspend";
        # }
      ];
      events = [
        { event = "before-sleep"; command = (display "off") + "; " + lock; }
        { event = "after-resume"; command = display "on"; }
        { event = "lock"; command = (display "off") + "; " + lock; }
        { event = "unlock"; command = display "on"; }
      ];
    };

  services.swaync = {
    enable = true;
  };

  services.swww.enable = true;

}
