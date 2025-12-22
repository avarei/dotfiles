{...}: {
  imports = [
    ./editor/neovim.nix
    ./git.nix
    ./global.nix
    ../stylix.nix
    ./shell/nushell.nix
    ./shell/zsh.nix
    ./shell/tmux.nix
    ./gpg.nix
    ./gui
    ./selfhosted/jellyfin.nix
    ./selfhosted/copyparty.nix
  ];
}
