{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  cfg = config.dotfiles.selfhosted.immich;
in {
  options.dotfiles.selfhosted.immich = {
    enable = lib.mkEnableOption "immich";
  };
  config = lib.mkIf cfg.enable {
    # Home Assistant native service
    services.immich = {
      enable = true;
      port = 2283;
      host = "0.0.0.0";
      openFirewall = true;
      accelerationDevices = ["/dev/dri/renderD128"];
      mediaLocation = "/var/lib/immich";
    };
    users.users.immich.extraGroups = ["video" "render"];
  };
}
