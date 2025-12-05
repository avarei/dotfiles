{pkgs, ...}: {
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
      user.signingkey = "F47E71666F3E317F";

      init = {defaultBranch = "main";};
      push = {autoSetupRemote = true;};
    };

    delta = {
      enable = true;
    };
  };
}
