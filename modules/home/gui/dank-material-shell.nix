{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.dank-material-shell;
in {
  options.dotfiles.gui.dank-material-shell = {
    enable = lib.mkEnableOption "dank-material-shell";
  };
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    programs.dank-material-shell = {
      enable = true;
      niri = {
        enableKeybinds = true;
        enableSpawn = true;
      };
    };
  };
}
