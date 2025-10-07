{ config, pkgs, ... }:

{
  imports = [
    ./home/global.nix
    ./home/editor/neovim.nix
    ./home/git.nix
    ./home/shell/nushell.nix
    ./home/shell/zsh.nix
    ./home/gpg.nix
    ./home/shell/tmux.nix
    ./home/gui/firefox.nix
    ./home/gui/niri.nix
    ./home/gui/ghostty.nix
    ./home/gaming/minecraft-client.nix
  ];

  home = {
    packages = with pkgs; [
      discord
      pureref
    ];
    sessionVariables = {
      SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
    };
  };
}
