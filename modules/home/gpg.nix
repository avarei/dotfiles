{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.dotfiles;
in {
  options.dotfiles.gpg = {
    enable = lib.mkEnableOption "gpg";
  };
  options.dotfiles.gpg-agent = {
    enable = lib.mkEnableOption "gpg-agent";
  };
  config = {
    programs.gpg = lib.mkIf cfg.gpg.enable {
      enable = true;
      publicKeys = [
        {
          text = ''
            -----BEGIN PGP PUBLIC KEY BLOCK-----

            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
            =1XF6
            -----END PGP PUBLIC KEY BLOCK-----
          '';
          trust = "ultimate";
        }
      ];
    };
    services.gpg-agent = lib.mkIf cfg.gpg-agent.enable {
      enable = true;
      pinentry.package =
        if pkgs.stdenv.isDarwin
        then pkgs.pinentry_mac
        else if config.dotfiles.gui.enable
        then pkgs.pinentry-gnome3
        else pkgs.pinentry-curses;
      enableSshSupport = true;
      enableExtraSocket = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    home.sessionVariables = lib.mkIf cfg.gpg-agent.enable {
      SSH_AUTH_SOCK = lib.mkIf config.dotfiles.gpg.enable "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
    };
  };
}
