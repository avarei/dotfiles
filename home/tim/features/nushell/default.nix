{ config, pkgs, lib, ... }:
{
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
      ll = "ls -lah";
      vi = "nvim";
      vim = "nvim";
    };
      
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}

