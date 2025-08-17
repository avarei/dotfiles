{ config, inputs, lib, pkgs, ... }:
{
  networking = {
    bridges.br0.interfaces = [ "enp2s0" ];
    useDHCP = false;

    interfaces."br0" = {
      useDHCP = true;
      macAddress = let
        generateMacAddress = seed:
          let
            hash = builtins.hashString "sha256" seed;
            octet = offset: builtins.substring offset 2 hash;
          in
            "02:${octet 2}:${octet 4}:${octet 6}:${octet 8}:${octet 10}";
        in
          generateMacAddress (config.networking.hostName + "-br0");
    };

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "enp2s0";
      enableIPv6 = true;
    };
  };

  containers.jellyfin = {
    enableTun = true;
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    extraFlags = [ "-U" ];
    bindMounts.data = {
      hostPath = "/home/tim/data/jellyfin";
      mountPoint = "/var/lib/jellyfin";
      isReadOnly = false;
    };
    config = { config, pkgs, lib, ... }: {
      services.jellyfin = {
        enable = true;
        openFirewall = true;
        dataDir = "/var/lib/jellyfin";
      };
      environment.systemPackages = [
        pkgs.jellyfin
        pkgs.jellyfin-web
        pkgs.jellyfin-ffmpeg
      ];
      networking = {
        firewall.allowedTCPPorts = [ 8096 ];

        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
      system.stateVersion = "25.05";
    };
  };
}
