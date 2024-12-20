{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # git # Required for lazy.nvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
}
