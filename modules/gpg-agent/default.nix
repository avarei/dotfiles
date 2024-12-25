{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      gnupg
    ];
  };
  programs.ssh = {
    enable = true;
    startAgent = true;
    agentOptions = {
      enableSSHSupport = true;
    };
  };
  programs.gpg = {
    enable = true;
    homedir = config.home.homeDirectory;
    defaultCacheTtl = 1800;
    maxCacheTtl = 7200;
  };
  services.gpg-agent = {
    enable = true;
    enableSSHSupport = true;
    enableZshIntegration = true;
    defaultCacheTtl = 1800;
    maxCacheTtl = 7200;
    
  };
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$(${programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
  };
  
  programs.git = {
    enable = true;
    userName = "Tim Geimer";
    userEmail = "32556895+Avarei@users.noreply.github.com";

    extraConfig = {
      credential = {
        helper = "cache --timeout=36000";
      };

      push = { autoSetupRemote = true; };
    };

  };
}
