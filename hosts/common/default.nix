{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    ../../modules/nixos/gpg
  ];
  
  environment.systemPackages = with pkgs; [
    direnv
  ];

  # for zsh completion of system packages
  environment.pathsToLink = [ "/share/zsh" ];

  time.timeZone = "Europe/Berlin";

  users.users.tim.packages = [ pkgs.home-manager ];

  programs.zsh.enable = true;

  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      allowed-users = [ "tim" ];
      trusted-users = [ "@wheel" "tim" ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
    options = "shift:breaks_caps";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    isNormalUser = true;
    description = "Tim";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/tim/ssh.pub) ];
  };

}
