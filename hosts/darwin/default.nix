{ config, pkgs, ... }:

let user = "tim"; in
{

  imports = [
    # ../../modules/darwin/secrets.nix
    # ../../modules/darwin/home-manager.nix
    # ../../modules/shared
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
