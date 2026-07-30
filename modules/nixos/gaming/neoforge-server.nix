{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.gaming.neoforge-server;
  dataDir = "/var/lib/minecraft-neoforge";
in {
  options.dotfiles.gaming.neoforge-server = {
    enable = lib.mkEnableOption "neoforge-server";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    virtualisation.oci-containers = {
      backend = "podman";
      containers.neoforge-server = {
        image = "itzg/minecraft-server:latest";
        autoStart = true;
        ports = ["25565:25565"];
        volumes = ["${dataDir}:/data"];
        environment = {
          EULA = "TRUE";
          TYPE = "NEOFORGE";
          VERSION = "1.21.1";
          MEMORY = "4G";
          MOTD = "baby on board";
          MAX_PLAYERS = "5";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 root root -"
    ];

    networking.firewall.allowedTCPPorts = [25565];
    networking.firewall.allowedUDPPorts = [25565];
  };
}
