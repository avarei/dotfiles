{}:
{
  networking = {
    bridges.br0.interfaces = [ "enp2s0" ];
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "enp2s0";
      enableIPv6 = true;
    };
  };

  containers.copyparty = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    extraFlags = [ "-U" ];
    # localAddress = "1.2.3.4/24";
    config = { config, pkgs, lib, ... }: {
      services.httpd = {
        enable = true;
        adminAddr = "admin@example.org";
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
