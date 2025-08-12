{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/nushell
    ./features/gpg
    ./features/tmux
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
