{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.plasma;
in {
  options.dotfiles.gui.plasma = {
    enable = lib.mkEnableOption "KDE Plasma 6 desktop";
  };
  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
