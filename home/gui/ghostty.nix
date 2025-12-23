{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.ghostty;
in {
  options.dotfiles.gui.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      settings = {background-opacity = 0.8;};
    };
  };
}
