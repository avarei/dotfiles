{ config, inputs, lib, pkgs, ... }:

{
  imports = [  ];
  
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
}
