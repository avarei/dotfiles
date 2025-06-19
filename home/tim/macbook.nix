{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/editor/vscode.nix
    ./features/git
    ./features/zsh
    ./features/gpg
    ./features/moonlight
    # ./modules/home/ssh
  ];
  home.homeDirectory = "/Users/${config.home.username}";
}
