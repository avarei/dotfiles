{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    pulseaudio
  ];
  programs.eww = {
    enable = true;
    enableZshIntegration = true;
    configDir = ./eww;
  };
}
