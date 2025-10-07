{ config, inputs, lib, pkgs, ... }:

{
  imports = [  ];
  
  programs.hyprland.enable = true;

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
    pkgs.kitty
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
