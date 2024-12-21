{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # git # Required for lazy.nvim
  ];

  # users.defaultUserShell = pkgs.zsh;
  # environment.shells = [ pkgs.zsh ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # vim = "nvim";
    };

    history = {
      size = 10000;
    };

    # zplug = {
    #   enable = true;
    #   plugins = [
    #   ];
    # };
  };
}

