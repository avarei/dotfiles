{ pkgs, ... }:
{
  services.podman = {
    enable = true;
    # networks = {
    #   jellyfin = {
    #     driver = "bridge";
    #     subnet = "172.22.0.0/24";
    #   };
    # };
    containers = {
      "jellyfin" = {
        image = "ghcr.io/jellyfin/jellyfin:10.10.7";
        description = "Jellyfin";
        volumes = [
          "/home/tim/data/jellyfin/config:/config"
          "/home/tim/data/jellyfin/cache:/cache"
        ];
        ports = [
          "8096:8096"
        ];
        # network = [ "jellyfin" ];
        user = 60000;
        group = 60000;
      };
    };
  };
}
