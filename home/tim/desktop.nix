{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/zsh
    ./features/nushell
    ./features/gpg
    ./features/browser/firefox.nix
    # ./features/gui/hyprland.nix
    ./features/gui/niri.nix
    ./features/gui/widgets/eww.nix
  ];

  home = {
    packages = with pkgs; [
      discord
    ];
  };
}
