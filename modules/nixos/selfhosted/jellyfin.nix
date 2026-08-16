{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.selfhosted.jellyfin;
in {
  options.dotfiles.selfhosted.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";
  };
  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
