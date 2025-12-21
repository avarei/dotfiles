{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.git;
in {
  options.dotfiles.git = {
    enable = lib.mkEnableOption "Enable Git Configuration";
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        git
      ];
    };
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
    programs.git = {
      enable = true;

      settings = {
        user.name = "Tim Geimer";
        user.email = "32556895+Avarei@users.noreply.github.com";
        user.signingkey = "F47E71666F3E317F";
        credential = {
          helper = "cache --timeout=36000";
        };
        commit.gpgSign = false;

        init = {defaultBranch = "main";};
        push = {autoSetupRemote = true;};
      };
      includes = [
        {
          condition = "hasconfig:remote.*.url:git@github.com:*/**";
          contents = {
            user = {
              name = "Tim Geimer";
              email = "32556895+Avarei@users.noreply.github.com";
            };
            commit.gpgSign = true;
          };
        }
        {
          condition = "hasconfig:remote.*.url:git@gitlab.opencode.de:*/**";
          contents = {
            user = {
              name = "Tim Geimer";
              email = "3679-tim.geimer@users.noreply.gitlab.opencode.de";
            };
            commit.gpgSign = true;
          };
        }
      ];
    };
  };
}
