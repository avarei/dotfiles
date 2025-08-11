{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
in {
  imports = [
    ../common
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
    };
  };

  services = {
    openssh = {
      enable = true;
      extraConfig = "StreamLocalBindUnlink yes";
    };
  };

  users.users = {
    tim = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "docker" # Allow Docker usage
      ];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/tim/ssh.pub) ];
    };
  };

  system.stateVersion = "24.11"; # Don't change this
}
