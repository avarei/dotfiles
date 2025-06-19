{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
in {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/gpg
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
      allowed-users = [ "tim" ];
      trusted-users = [ "@admin" "tim" ];
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
        baobab
        epiphany
        evince
        geary
        gnome-backgrounds
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-connections
        gnome-contacts
        gnome-disk-utility
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-software
        gnome-tour
        gnome-text-editor
        gnome-user-docs
        gnome-weather
        orca
        simple-scan
        snapshot
        totem
        yelp
      ];
    };
  };

  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  

  users.users = {
    tim = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker" # Allow Docker usage
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/tim/ssh.pub) ];
    };
  };

  system.stateVersion = "24.11"; # Don't change this
}
