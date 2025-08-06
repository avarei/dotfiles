{ config, pkgs, lib, inputs, ... }: {

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
  };

} 
