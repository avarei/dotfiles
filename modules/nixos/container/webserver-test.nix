{ config, inputs, lib, pkgs, ... }:
{
  networking = {
    bridges.br0.interfaces = [ "enp2s0" ];
    useDHCP = false;

    interfaces."br0".useDHCP = true;

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "enp2s0";
      #enableIPv6 = true;
    };
  };

  containers.webserver = {
    enableTun = true;
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    extraFlags = [ "-U" ];
    config = { config, pkgs, lib, ... }: {
      services.static-web-server = {
        enable = true;
        listen = "[::]:8080";
        root = "/tmp";
      };
      networking = {
        firewall.allowedTCPPorts = [ 8080 ];

        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
      system.stateVersion = "25.05";
    };
  };
}
