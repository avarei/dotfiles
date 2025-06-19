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
}
