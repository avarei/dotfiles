{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.selfhosted.copyparty;
  dataDir = "/var/lib/copyparty";
in {
  options.dotfiles.selfhosted.copyparty = {
    enable = lib.mkEnableOption "copyparty";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;
    virtualisation.oci-containers = {
      backend = "podman";
      containers.copyparty = {
        image = "ghcr.io/9001/copyparty-ac:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${dataDir}/config:/cfg"
          "${dataDir}/data:/w"
        ];
        ports = ["3923:3923"];
        extraOptions = ["--user=60000:60000"];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 60000 60000 -"
      "d ${dataDir}/config 0750 60000 60000 -"
      "d ${dataDir}/data 0750 60000 60000 -"
    ];
  };
}
