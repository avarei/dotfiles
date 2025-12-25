{
  config,
  lib,
  ...
}: {
  imports = [
    ./editor/neovim.nix
    ./git.nix
    ./global.nix
    ../shared/stylix.nix
    ./shell/nushell.nix
    ./shell/zsh.nix
    ./shell/tmux.nix
    ./gpg.nix
    ./gui
    ./selfhosted/jellyfin.nix
    ./selfhosted/copyparty.nix
  ];

  home = {
    sessionVariables = {
      SSH_AUTH_SOCK = lib.mkIf config.dotfiles.gpg.enable "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
      EDITOR = lib.mkIf config.dotfiles.editor.neovim.enable "nvim";
    };
  };
  programs.nushell.envFile.text = lib.concatStringsSep "\n" (
    [
      "$env.GTK_IM_MODULE = \"simple\";"
    ]
    ++ lib.optional config.dotfiles.gpg.enable "$env.SSH_AUTH_SOCK = ^${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket"
    ++ lib.optional config.dotfiles.editor.neovim.enable "$env.EDITOR = 'nvim'"
  );
}
