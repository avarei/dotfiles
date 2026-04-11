{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.gaming.factorio-server;
in {
  options.dotfiles.gaming.factorio-server = {
    enable = lib.mkEnableOption "factorio-server";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.factorio-headless];

    services.factorio = {
      enable = true;
      openFirewall = true;
      requireUserVerification = false;
      autosave-interval = 10;
      extraSettings = {
        auto_pause = true;
      };
      admins = [
        "avarei"
      ];
    };
  };
}
