{config, ...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    settings = {
      background-opacity = 0.8;
    };
  };
}
