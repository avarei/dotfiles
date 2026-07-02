{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.virtualisation.podman;
in {
  options.dotfiles.virtualisation.podman = {
    enable = lib.mkEnableOption "podman";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    environment.systemPackages = [pkgs.podman-compose];
  };
}
