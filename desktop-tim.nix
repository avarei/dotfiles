{
  lib,
  config,
  pkgs,
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
  };
}
