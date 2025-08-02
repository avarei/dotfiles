{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      git
    ];
  };
  programs.git = {
    enable = true;
    userName = "Tim Geimer";
    userEmail = "32556895+Avarei@users.noreply.github.com";

    extraConfig = {
      credential = {
        helper = "cache --timeout=36000";
      };
      commit.gpgSign = true;
      user.signingkey = "E8722A4C7EB2CD4C";


      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
    };

  };
}
