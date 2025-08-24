{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
in {
  imports = [
    ../common/linux.nix
    ./hardware-configuration.nix
  ];

  networking.nat.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      extraConfig = "StreamLocalBindUnlink yes";
    };
  };

  networking = {
    hostName = "server";
    networkmanager.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3923 8096 22 ];
    };
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
  system.stateVersion = "24.11"; # Don't change this
}
