{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/nushell.nix
    ./features/zsh.nix
    ./features/gpg
    ./features/tmux.nix
    ./features/browser/firefox.nix
    ./features/gui/hyprland.nix
    ./features/gui/niri.nix
    ./features/gui/widgets/eww.nix
  ];

  home = {
    packages = with pkgs; [
      discord
    ];
    sessionVariables = {
      SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
    };
  };
}
