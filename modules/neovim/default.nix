{ config, pkgs, lib, nixvim, ... }:


{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];
  home = {
    packages = with pkgs; [
      # git # Required for lazy.nvim
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;

    globals.mapleader = " ";

  };

  programs.zsh = {
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };
}
