{ config, inputs, lib, pkgs, ... }:

{
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    description = "Tim";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [ (builtins.readFile ../../home/tim/ssh.pub) ];
  };

}
