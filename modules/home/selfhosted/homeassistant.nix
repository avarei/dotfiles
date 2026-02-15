{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.selfhosted.homeassistant;
in {
  options.dotfiles.selfhosted.homeassistant = {
    enable = lib.mkEnableOption "homeassistant";
  };
  config = lib.mkIf cfg.enable {
    services.podman = {
      enable = true;
      containers = {
        "homeassistant" = {
          image = "ghcr.io/home-assistant/home-assistant:stable";
          description = "Home Assistant";
          volumes = [
            "/home/tim/data/homeassistant/config:/config"
            "/etc/localtime:/etc/localtime:ro"
            "/run/dbus:/run/dbus:ro"
          ];
          network = "host";
          devices = [
            "/dev/ttyUSB0:/dev/ttyUSB0"
          ];
          addCapabilities = [
            "CAP_NET_RAW"
            "CAP_NET_ADMIN"
          ];
        };
      };
    };
  };
}
