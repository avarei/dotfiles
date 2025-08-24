{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
in {
  imports = [
    ../common/linux.nix
    ./hardware-configuration.nix
    ./gpu.nix
    ../features/gui/hyprland.nix
    # ../features/gui/gnome.nix
    ../features/gui/niri.nix
    ../features/gaming/steam.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["resume_offset=41463808"];
    resumeDevice = "/dev/disk/by-label/NIXROOT";
  };

  powerManagement.enable = true;
  
  networking = {
    hostName = "desktop";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    os-prober
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

