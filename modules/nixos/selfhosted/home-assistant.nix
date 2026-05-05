{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  cfg = config.dotfiles.selfhosted.homeassistant;
in {
  options.dotfiles.selfhosted.homeassistant = {
    enable = lib.mkEnableOption "homeassistant";
  };
  config = lib.mkIf cfg.enable {
    # Use unstable openthread-border-router package (module imported from unstable)
    nixpkgs.overlays = [
      (final: prev: {
        openthread-border-router = pkgs-unstable.openthread-border-router;
      })
    ];

    # udev rules for serial device access
    services.udev.extraRules = ''
      # Zigbee coordinator
      SUBSYSTEM=="tty", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", SYMLINK+="ttyUSB0", MODE="0660", GROUP="dialout"
      # ZBT-2 Thread radio (accessed by OTBR service)
      SUBSYSTEM=="tty", ATTRS{product}=="ZBT-2*", MODE="0660", GROUP="dialout"
    '';

    # Home Assistant native service
    services.home-assistant = {
      enable = true;
      configDir = "/var/lib/hass";
      extraPackages = ps: [
        ps.pyatv # Required for Apple TV integration and device triggers
      ];
      extraComponents = [
        "matter"
        "otbr"
        "thread"
        "zha" # Zigbee Home Automation for the USB coordinator
        "homekit" # HomeKit integration
      ];
      config = {
        homeassistant = {
          name = "Home";
          time_zone = "Europe/Berlin";
        };
        http = {
          server_port = 8123;
        };
        zha = {
          usb_path = "/dev/ttyUSB0";
        };
        # Enable default integrations
        default_config = {};
      };
    };

    # OpenThread Border Router (uses ZBT-2 for Thread)
    services.openthread-border-router = {
      enable = true;
      backboneInterfaces = ["enp2s0"];
      radio = {
        device = "/dev/serial/by-id/usb-Nabu_Casa_ZBT-2_E072A1FADAB4-if00";
        baudRate = 460800;
        flowControl = true;
      };
      rest = {
        listenAddress = "127.0.0.1";
        listenPort = 8081;
      };
      web = {
        enable = true;
        listenAddress = "127.0.0.1";
        listenPort = 58082;
      };
    };

    # Matter Server for Matter device support
    services.matter-server = {
      enable = true;
      port = 5580;
      logLevel = "info";
    };

    networking.firewall = {
      allowedTCPPorts = [
        8123 # Home Assistant
        21064 # HomeKit
        8081 # OTBR REST API
        5580 # Matter Server
      ];
      allowedUDPPorts = [5353]; # mDNS
    };
  };
}
