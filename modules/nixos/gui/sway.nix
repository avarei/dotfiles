{
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.gui.sway;
in {
  options.dotfiles.gui.sway = {
    enable = lib.mkEnableOption "sway";
  };
  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.sessionVariables = {
      GTK_IM_MODULE = "simple";
    };

    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "sway";
      configHome = "/home/tim";
    };
  };
}
