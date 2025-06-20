{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      # gnupg
    ];
  };
  programs.gpg = {
    enable = true;
    publicKeys = [
      { text = ''
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        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
        q56IrnRlQwg=
        =xwfX
        -----END PGP PUBLIC KEY BLOCK-----
      '';
      trust = "ultimate";}
    ];
  };
  services.gpg-agent.enableSshSupport = true;

  # home.sessionVariables = {
  #   SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
  # };

}
