{
  config,
  lib,
  ...
}: {
  imports = [
    ./modules/home
  ];
  dotfiles = {
    editor.neovim.enable = true;
    git.enable = true;
    shell.nushell.enable = true;
    shell.zsh.enable = true;
    shell.tmux.enable = true;
    gpg.enable = true;
    gui.ghostty.enable = false; # currently the package is broken for macOS: https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/gh/ghostty/package.nix#L192
  };
  home = {
    homeDirectory = lib.mkForce "/Users/${config.home.username}";
    sessionVariables = {
      SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
      EDITOR = "nvim";
    };
  };
  programs.nushell.envFile.text = lib.mkForce ''
    $env.SSH_AUTH_SOCK = ^${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket
    $env.EDITOR = 'nvim'
  '';
}
