{ config, inputs, lib, pkgs, ... }:

let
  user = "tim";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0pJdZaqZ5hLS+PQExRJlOZpHij8LJH3BcL5a3Zd9Rc openpgp:0x45379177"
  ];
in {
  imports = [
    # ../../modules/nixos/disk-config.nix
    # ../../modules/shared
    ./hardware-configuration.nix
    ../../modules/nixos/gpg/default.nix
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

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Turn on flag for proprietary software
  nix = {
    nixPath =
      [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [ "@admin" "${user}" ];
      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys =
        [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nix;
  };

  # Manages keys and such
  programs = {
    # My shell
    zsh.enable = true;
  };

  services = {
    # Let's be able to SSH into this machine
    openssh = {
      enable = true;
      extraConfig = "StreamLocalBindUnlink yes";
    };
  };

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };
  };

  system.stateVersion = "24.11"; # Don't change this
}
