{ config, inputs, lib, pkgs, ... }:

{
  imports = [  ];
  
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

  security.pam.services.swaylock = {};

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };
}
