{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      # gnupg
    ];
  };
  programs.gpg = {
    enable = true;
    publicKeys = [
      { source = ./pubkey.txt; }
    ];
  };
  # home.sessionVariables = {
  #   SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
  # };

}
