{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      git
    ];
  };
  programs.git = {
    enable = true;
    userName = "Avarei";
    userEmail = "32556895+Avarei@users.noreply.github.com";

    extraConfig = {
      credential = {
        helper = "cache --timeout=36000";
      };
      commit.gpgSign = true;
      user.signingkey = "587E5A78B226A58F";


      push = { autoSetupRemote = true; };
    };

  };
}
