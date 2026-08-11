{
  config,
  pkgs,
  lib,
  dgop,
  ...
}: let
  cfg = config.dotfiles.gui;
in {
  config = lib.mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      dgop.package = dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
