{ config, pkgs, ... }:

{
  imports = [
    ./hosts/common.nix
  ];

  system.stateVersion = 5;
}
