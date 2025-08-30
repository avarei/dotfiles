{ config, pkgs, lib, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/nushell.nix
    ./features/zsh.nix
    ./features/gpg
    ./features/tmux.nix
    # ./features/gui/ghostty.nix # currently the package is broken for macOS: https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/gh/ghostty/package.nix#L192
  ];
  home.homeDirectory = lib.mkForce "/Users/${config.home.username}";
}
