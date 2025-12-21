{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles.shell.zsh;
  shellAliases = {
    ll = "ls -lah";
  };
  nixvimShellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
in {
  imports = [
    ./starship.nix
  ];
  options.dotfiles.shell.zsh = {
    enable = lib.mkEnableOption "Enable Zsh Configuration";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # git # Required for lazy.nvim
      direnv
    ];
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = shellAliases // nixvimShellAliases;

      history = {
        size = 10000;
      };

      initContent = ''
        bindkey "\e[1;3D" backward-word
        bindkey "\e[1;5D" backward-word
        bindkey "\e[1;3C" forward-word
        bindkey "\e[1;5C" forward-word
        bindkey "\e[3~" delete-char
        bindkey "\e[1~" beginning-of-line
        bindkey "\e[4~" end-of-line
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line

        umask 022
      '';

      defaultKeymap = "emacs";

      zplug = {
        enable = true;
        plugins = [
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = ["as:plugin"];
          }
          {
            name = "zsh-users/zsh-syntax-highlighting";
            tags = ["defer:2"];
          }
          {
            name = "plugins/git";
            tags = ["from:oh-my-zsh"];
          }
          {
            name = "plugins/kubectl";
            tags = ["from:oh-my-zsh"];
          }
          {
            name = "plugins/helm";
            tags = ["from:oh-my-zsh"];
          }
          {
            name = "plugins/docker";
            tags = ["from:oh-my-zsh"];
          }
          {
            name = "plugins/cp";
            tags = ["from:oh-my-zsh"];
          }
          {
            name = "plugins/man";
            tags = ["from:oh-my-zsh"];
          }
        ];
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      # Conifg written to ~/.config/starship.toml
      settings = {
        # add_newline = false;

        # character = {
        #   success_symbol = "[➜](bold green)";
        #   error_symbol = "[➜](bold red)";
        # };
      };
    };
  };
}
