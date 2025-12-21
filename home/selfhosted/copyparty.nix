{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.selfhosted.copyparty;
in {
  options.dotfiles.selfhosted.copyparty = {
    enable = lib.mkEnableOption "Enable Copyparty Configuration";
  };
  config = lib.mkIf cfg.enable {
    services.podman = {
      enable = true;
      containers = {
        "copyparty" = {
          image = "ghcr.io/9001/copyparty-ac:1.19.4";
          description = "Copyparty";
          volumes = [
            "/home/tim/data/copyparty/config:/cfg"
            "/home/tim/data/copyparty/data:/w"
          ];
          ports = [
            "3923:3923"
          ];
          user = 60000;
          group = 60000;
        };
      };
    };
  };
}
