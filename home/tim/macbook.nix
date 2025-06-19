{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/editor/vscode.nix
    ./features/git
    ./features/zsh
    ./features/gpg
    # ./modules/home/ssh
  ];
  home.homeDirectory = "/Users/${config.home.username}";
}
