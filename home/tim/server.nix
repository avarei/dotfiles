{ config, pkgs, ... }:

{
  imports = [
    ./global
    ./features/editor/neovim.nix
    ./features/git
    ./features/zsh.nix
    ./features/gpg
    ./features/selfhosted/jellyfin.nix
    ./features/selfhosted/copyparty.nix
  ];

}
