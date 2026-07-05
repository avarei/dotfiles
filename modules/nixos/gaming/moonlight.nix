{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.gaming.moonlight;
in {
  options.dotfiles.gaming.moonlight = {
    enable = lib.mkEnableOption "moonlight game streaming client";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.moonlight-qt];
  };
}
