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
      user.signingkey = "5772654A0D090E3D";


      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
    };

  };
}
