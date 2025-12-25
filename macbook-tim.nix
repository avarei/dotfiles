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
    gui.ghostty.enable = false;
  };
  home = {
    homeDirectory = "/Users/${config.home.username}";
  };
}
