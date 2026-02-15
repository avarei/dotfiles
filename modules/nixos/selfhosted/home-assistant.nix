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
    virtualisation.oci-containers = {
      backend = "podman";
      containers.homeassistant = {
        volumes = ["/root/data/home-assistant/config:/config"];
        environment.TZ = "Europe/Berlin";
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [
          # Use the host network namespace for all sockets
          "--network=host"
          "--device=/dev/ttyUSB0:/dev/ttyUSB0"
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [8123];
  };
}
