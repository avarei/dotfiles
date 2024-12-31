{ config, inputs, lib, pkgs, ... }:

let
  user = "tim";
in {
  imports = [  ];

  # Manages keys and such
  programs = {
    # My shell
    zsh.enable = true;
  };

  time.timeZone = "Europe/Berlin";
}
