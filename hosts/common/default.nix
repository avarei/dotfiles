{ config, inputs, lib, pkgs, ... }:

let
  user = "tim";
in {
  imports = [  ];
  
  environment.systemPackages = with pkgs; [
    direnv
  ];

  # Manages keys and such
  programs = {
    # My shell
    zsh.enable = true;
  };

  time.timeZone = "Europe/Berlin";
}
