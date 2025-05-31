{ config, inputs, lib, pkgs, username, keys, ... }:

let
  foo = "bar";
in {
  imports = [
    # ../../modules/nixos/disk-config.nix
    # ../../modules/shared
    ./hardware-configuration.nix
    ../../modules/nixos/gpg/default.nix
    # ../../modules/nixos/kubernetes/default.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Turn on flag for proprietary software
  nix = {
    settings = {
      allowed-users = [ "${username}" ];
      trusted-users = [ "@admin" "${username}" ];
      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys =
        [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nix;
  };

  services = {
    # Let's be able to SSH into this machine
    openssh = {
      enable = true;
      extraConfig = "StreamLocalBindUnlink yes";
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    k3s.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-terminal
    ];
    gnome = {
      excludePackages = with pkgs; [
        orca
        evince
        # file-roller
        geary
        gnome-disk-utility
        # seahorse
        # sushi
        # sysprof
        #
        # gnome-shell-extensions
        #
        # adwaita-icon-theme
        # nixos-background-info
        gnome-backgrounds
        # gnome-bluetooth
        # gnome-color-manager
        # gnome-control-center
        # gnome-shell-extensions
        gnome-tour # GNOME Shell detects the .desktop file on first log-in.
        gnome-user-docs
        # glib # for gsettings program
        # gnome-menus
        # gtk3.out # for gtk-launch program
        # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        # xdg-user-dirs-gtk # Used to create the default bookmarks
        #
        baobab
        epiphany
        gnome-text-editor
        gnome-calculator
        gnome-calendar
        gnome-characters
        # gnome-clocks
        # gnome-console
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        # gnome-system-monitor
        gnome-weather
        # loupe
        # nautilus
        gnome-connections
        simple-scan
        snapshot
        totem
        yelp
        gnome-software
      ];
    };
  };

  virtualisation.docker.enable = true;
  

  users.users = {
    ${username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker" # Allow Docker usage
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [keys];
    };
  };

  system.stateVersion = "24.11"; # Don't change this
}
