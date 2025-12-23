{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.gaming.steam;
in {
  options.dotfiles.gaming.steam = {
    enable = lib.mkEnableOption "Enable Steam Configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    hardware.xone.enable = true;
  };
}
