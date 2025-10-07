{ config, pkgs, lib, ... }:
{
  imports = [
    ./starship.nix
  ];
  home.packages = with pkgs; [
    direnv
  ];
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    settings = {
      history = {
        file_format = "sqlite";
        max_size = 1000000;
        sync_on_enter = true;
        isolation = true;
      };
      show_banner = false;

      buffer_editor = "nvim";
    };
    shellAliases = {
      ll = "ls -a";
      vi = "nvim";
      vim = "nvim";
    };
    envFile.text = ''
      $env.SSH_AUTH_SOCK = ^${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket
      $env.EDITOR = 'nvim'
    '';

    # workaround for non nixos systems to set the correct envrionemnt variables
    # https://github.com/nix-darwin/nix-darwin/issues/1028
    extraLogin = lib.mkIf false ''
      if "_SOURCED_BASH" not-in $env {
        load-env (bash -l -i -c "nu -c '$env | to yaml'" | from yaml | reject -i
          config _ FILE_PWD PWD SHLVL CURRENT_FILE
          STARSHIP_SESSION_KEY
          PROMPT_COMMAND
          PROMPT_COMMAND_RIGHT
          PROMPT_INDICATOR
          PROMPT_INDICATOR_VI_INSERT
          PROMPT_INDICATOR_VI_NORMAL
          PROMPT_MULTILINE_INDICATOR
          TRANSIENT_PROMPT_COMMAND_RIGHT
          TRANSIENT_PROMPT_MULTILINE_INDICATOR
        )
        $env._SOURCED_BASH = true
      }
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

}

