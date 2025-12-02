{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home/global.nix
    ./home/editor/neovim.nix
    ./home/git.nix
    ./home/shell/nushell.nix
    ./home/shell/zsh.nix
    ./home/gpg.nix
    ./home/shell/tmux.nix
    # ./home/gui/ghostty.nix # currently the package is broken for macOS: https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/gh/ghostty/package.nix#L192
  ];
  home.homeDirectory = lib.mkForce "/Users/${config.home.username}";
}
