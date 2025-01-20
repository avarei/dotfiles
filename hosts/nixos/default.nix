{ config, inputs, lib, pkgs, ... }:

let
  user = "tim";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICF+5SPqVaw3+0T/BKmlimufxLgW+tHnPyhCyxYz9aZf openpgp:0x0D090E3D"
  ];
in {
  imports = [
    # ../../modules/nixos/disk-config.nix
    # ../../modules/shared
    ./hardware-configuration.nix
    ../../modules/nixos/gpg/default.nix
    ../../modules/nixos/kubernetes/default.nix
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
