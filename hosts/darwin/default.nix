{ config, pkgs, ... }:

let user = "tim"; in
{

  imports = [
    # ../../modules/darwin/secrets.nix
    # ../../modules/darwin/home-manager.nix
    # ../../modules/shared
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
}