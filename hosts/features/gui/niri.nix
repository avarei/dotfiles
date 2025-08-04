{ config, inputs, lib, pkgs, ... }:

{
  imports = [  ];
  
  programs.niri.enable = true;

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
}
