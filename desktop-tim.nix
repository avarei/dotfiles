{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./home
  ];
  dotfiles = {
    editor.neovim.enable = true;
    git.enable = true;
    shell.nushell.enable = true;
    shell.zsh.enable = true;
    shell.tmux.enable = true;
    gpg.enable = true;
    gui = {
      enable = true;
      niri.enable = true;
      ghostty.enable = true;
      firefox.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      discord
      prismlauncher # minecraft client
    ];
    sessionVariables = {
      SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
      EDITOR = "nvim";
    };
  };
  programs.nushell.envFile.text = lib.mkForce ''
    $env.SSH_AUTH_SOCK = ^${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket
    $env.EDITOR = 'nvim'
    $env.GTK_IM_MODULE = "simple";
  '';
}
