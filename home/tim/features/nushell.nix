{ config, pkgs, lib, ... }:
{
  imports = [
    ./starship.nix
  ];
  home.packages = with pkgs; [
    direnv
  ];
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    settings = {
      history = {
        file_format = "sqlite";
        max_size = 1000000;
        sync_on_enter = true;
        isolation = true;
      };
      show_banner = false;

      buffer_editor = "nvim";
    };
    shellAliases = {
      ll = "ls -a";
      vi = "nvim";
      vim = "nvim";
    };
    envFile.text = ''
      $env.SSH_AUTH_SOCK = ^${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket
    '';
      
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

}

