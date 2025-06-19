{ config, pkgs, ... }:

let foo = "bar";
in {

  imports = [
    ../common
    ../../modules/darwin/gpg
  ];

  system.stateVersion = 5;
}
