{ config, inputs, lib, pkgs, ... }:

{
  imports = [  ];
  
  environment.systemPackages = with pkgs; [
    direnv
  ];

  # for zsh completion of system packages
  environment.pathsToLink = [ "/share/zsh" ];


  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;

  users.users.tim.packages = [ pkgs.home-manager ];

}
