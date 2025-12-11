{
  config,
  lib,
  ...
}: {
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
  programs.nushell.envFile.text = lib.mkForce ''
    $env.EDITOR = 'nvim'
    $env.GTK_IM_MODULE = "simple";
  '';
}
