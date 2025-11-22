{ config, pkgs, ... }: {

  programs.ghostty = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      theme = "catppuccin-mocha";
      background-opacity = 0.5;
    };
  };
}
