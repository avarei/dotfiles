{ pkgs, ... }:
{
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
}
