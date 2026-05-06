{
  config,
  lib,
  pkgs-unstable,
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
      package = pkgs-unstable.niri;
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

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/tim";
    };
  };
}
