{ config, inputs, lib, pkgs, ... }:

let
  user = "tim";
in {
  imports = [  ];
  
  environment.systemPackages = with pkgs; [
    direnv
  ];

  # for zsh completion of system packages
  environment.pathsToLink = [ "/share/zsh" ];


  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;
}
