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
      package = pkgs-unstable.home-assistant;
      configDir = "/var/lib/hass";
      extraPackages = ps: [
        ps.pyatv # Required for Apple TV integration and device triggers
        ps.aiohomekit # Required for HomeKit controller integration
      ];
      extraComponents = [
        "matter"
        "otbr"
        "thread"
        "zha" # Zigbee Home Automation for the USB coordinator
        "homekit" # HomeKit integration (expose HA to HomeKit)
        "homekit_controller" # Control HomeKit devices from HA
        "cast" # Chromecast / Google Cast support
      ];
      config = {
        homeassistant = {
          name = "Home";
          time_zone = "Europe/Berlin";
        };
        http = {
          server_port = 8123;
        };
        zha = {};
        lovelace = {
          mode = "storage";
        };
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
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

    # Avahi mDNS - OTBR advertising proxy registers Thread/Matter SRP records
    # through Avahi; raise the per-client object limit so it doesn't hit
    # "Too many objects" when pairing or when many devices are present
    services.avahi = {
      enable = true;
      extraConfig = ''
        [server]
        objects-per-client-max=2000
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [
        8123 # Home Assistant
        21064 # HomeKit
        8081 # OTBR REST API
        5580 # Matter Server
      ];
      allowedUDPPorts = [
        5353 # mDNS
        5540 # Matter protocol (commissioning + operational)
      ];
    };
  };
}
