{ config, pkgs, ... }:

{
  imports = [
    ./home/global.nix
    ./home/editor/neovim.nix
    ./home/git.nix
    ./home/shell/zsh.nix
    ./home/gpg.nix
    ./home/selfhosted/jellyfin.nix
    ./home/selfhosted/copyparty.nix
  ];

}
