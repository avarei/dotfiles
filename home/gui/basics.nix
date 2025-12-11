{
  pkgs,
  lib,
  ...
}: let
  lockscreenPhrases = [
    "What's up?"
    "Who's there?"
    "The Password is \"LOWERCASE all uppercase\""
    "I am ____ locked"
    "Upload Password to the Cloud"
    "Reading the ToS is considered a breach of Contract"
  ];
in {
  imports = [
    ../../modules/stylix.nix
  ];

  home.packages = with pkgs; [
    pavucontrol # audio in/out
    libnotify
    nautilus # filebrowser
    wl-clipboard-rs
    gparted # partition management
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

  stylix.targets.hyprlock.enable = false;
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      auth = {
        "pam:module" = "login";
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = [
        {
          # TIME
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 90;
          font_family = "$font";
          position = "0, -100";
          halign = "center";
          valign = "top";
        }
        {
          # DATE
          monitor = "";
          text = "cmd[update:43200000] date +\"%d.%m.%Y\"";
          color = "$text";
          font_size = 25;
          font_family = "$font";
          position = "0, -60";
          halign = "center";
          valign = "top";
        }
        {
          # Banner
          monitor = "";
          text = "cmd[] echo ${lib.strings.escapeShellArg (builtins.toJSON lockscreenPhrases)} | jq -r '.[]' | shuf -n1";
          color = "$text";
          font_size = 25;
          font_family = "$font";
          position = "0, 20";
          halign = "center";
          valign = "center";
        }
      ];

      # USER AVATAR
      # image = [
      #   {
      #     monitor = "";
      #     path = "$HOME/.face";
      #     size = 100;
      #     border_color = "$accent";
      #     position = "0, 75";
      #     halign = "center";
      #     valign = "center";
      #   }
      # ];

      # INPUT FIELD
      input-field = [
        {
          monitor = "";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          placeholder_text = "<span foreground=\"##$textAlpha\">󰌾 Logged in as <span foreground=\"##$accentAlpha\">$USER</span></span>";
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "$FAIL <b>($ATTEMPTS)</b>";
          capslock_color = "$yellow";
          position = "0, -47";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.swayidle = let
    # lock = "${pkgs.hyprlock}/bin/hyprlock";
    lock = "${pkgs.hyprlock}/bin/hyprlock";
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
  in {
    enable = true;
    timeouts = [
      # {
      #   timeout = (4 * 60); # in seconds
      #   command = "${pkgs.libnotify}/bin/notify-send 'Going to Sleep in 1 minute' -t 60000";
      # }
      {
        timeout = 5 * 60;
        command = display "off";
        resumeCommand = display "on";
      }
      # {
      #   timeout = (5 * 60) + 5;
      #   command = lock;
      # }
      # {
      #   timeout = 30;
      #   command = "${pkgs.systemd}/bin/systemctl suspend";
      # }
    ];
    events = [
      {
        event = "before-sleep";
        command = (display "off") + "; " + lock;
      }
      {
        event = "after-resume";
        command = display "on";
      }
      {
        event = "lock";
        command = (display "off") + "; " + lock;
      }
      {
        event = "unlock";
        command = display "on";
      }
    ];
  };

  services.swaync = {
    enable = true;
  };

  services.swww.enable = true;

  services.polkit-gnome.enable = true;
}
