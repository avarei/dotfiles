{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dotfiles.shell.tmux;
in {
  options.dotfiles.shell.tmux = {
    enable = lib.mkEnableOption "Enable Tmux Configuration";
  };
  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      shell = "${pkgs.nushell}/bin/nu";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_status_style 'rounded'

            set -g status-right "#{E:@catppuccin_status_application}"
          '';
        }
        {
          plugin = cpu;
          extraConfig = ''
            set -agF status-right "#{E:@catppuccin_status_cpu}"
          '';
        }
      ];
    };
  };
}
