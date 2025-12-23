{
  config,
  pkgs,
  lib,
  ...
}: {
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "tim";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    keyboard.layout = "us(intl)";

    packages = with pkgs; [
      jq
      yq
      tree
      htop
    ];
  };

  home.stateVersion = "24.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;
}
