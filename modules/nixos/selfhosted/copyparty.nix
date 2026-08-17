{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.selfhosted.copyparty;
  configDir = "/var/lib/copyparty";
  dataDir = "/srv/copyparty";
in {
  options.dotfiles.selfhosted.copyparty = {
    enable = lib.mkEnableOption "copyparty";
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [3923];
    networking.nat.enable = true;

    virtualisation.podman.enable = true;
    virtualisation.oci-containers = {
      backend = "podman";
      containers.copyparty = {
        image = "ghcr.io/9001/copyparty-ac:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${configDir}:/cfg"
          "${dataDir}:/w"
        ];
        ports = ["3923:3923"];
        extraOptions = ["--user=60000:60000"];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${configDir} 0750 60000 60000 -"
      "d ${dataDir} 0750 60000 60000 -"
    ];
  };
}
