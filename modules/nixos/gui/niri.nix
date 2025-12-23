{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.gui.niri;
in {
  options.dotfiles.gui.niri = {
    enable = lib.mkEnableOption "niri";
  };
  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = [
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;

    security.polkit.enable = true;
  };
}
