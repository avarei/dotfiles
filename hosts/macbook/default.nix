{ config, pkgs, ... }:

let user = "tim"; in
{

  imports = [
    ../common
    ../../modules/darwin/gpg
  ];


  # Setup user, packages, programs
  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  system.stateVersion = 5;
}
