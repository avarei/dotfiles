{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/zsh
    ./features/browser/firefox.nix
    ./features/gui/niri.nix
    ./features/gpg
  ];

  home = {
    packages = with pkgs; [
      discord
    ];
  };
}
