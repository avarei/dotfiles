{...}: {
  imports = [
    ./home/global.nix
    ./home/editor/neovim.nix
    ./home/git.nix
    ./home/shell/nushell.nix
    ./home/shell/zsh.nix
    ./home/shell/tmux.nix
    ./home/gpg.nix
    ./home/selfhosted/jellyfin.nix
    ./home/selfhosted/copyparty.nix
  ];
}
