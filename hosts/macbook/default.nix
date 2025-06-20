{ config, pkgs, ... }:

let foo = "bar";
in {

  imports = [
    ../common
  ];

  system.stateVersion = 5;
}
