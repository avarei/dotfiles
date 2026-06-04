{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  cfg = config.dotfiles.gui.hyprland;
in {
  options.dotfiles.gui.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = pkgs-unstable.hyprland;
      portalPackage = pkgs-unstable.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    # Hyprland's NixOS wrapper sets cap_sys_nice (for realtime scheduling) and
    # cap_setpcap. Hyprland then raises both as ambient on every child, which
    # makes bwrap refuse to run (Steam) and causes xdg-desktop-portal to fall
    # into suid-safe /proc access mode (Vesktop screenshare). rtkit covers the
    # realtime case without file caps, so clear them.
    security.wrappers.Hyprland.capabilities = lib.mkForce "";

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
      GTK_IM_MODULE = "simple";
    };

    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = lib.mkDefault "hyprland";
      configHome = "/home/tim";
    };
  };
}
