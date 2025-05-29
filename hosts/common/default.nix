{ config, inputs, lib, pkgs, ... }:

let
  user = "tim";
in {
  imports = [  ];
  
  environment.systemPackages = with pkgs; [
    direnv
  ];

  time.timeZone = "Europe/Berlin";
  nixpkgs.config.allowUnfree = true;
}
