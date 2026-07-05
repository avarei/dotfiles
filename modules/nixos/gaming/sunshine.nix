{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  cfg = config.dotfiles.gaming.sunshine;
in {
  options.dotfiles.gaming.sunshine = {
    enable = lib.mkEnableOption "sunshine game streaming server";
  };
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      openFirewall = true;
      capSysAdmin = true;
      package = pkgs-unstable.sunshine;
    };
  };
}
