{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.gaming.steam;
in {
  options.dotfiles.gaming.steam = {
    enable = lib.mkEnableOption "steam";
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    hardware.xone.enable = true;
    hardware.steam-hardware.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      wireplumber.extraConfig."51-index-audio" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {"device.name" = "alsa_card.pci-0000_01_00.1";}
            ];
            actions.update-props = {
              "device.profile" = "output:hdmi-stereo-extra1";
            };
          }
        ];
      };
    };
  };
}
