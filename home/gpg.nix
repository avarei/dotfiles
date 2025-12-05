{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          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
          q56IrnRlQwg=
          =xwfX
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        trust = "ultimate";
      }
      {
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          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
          yIgSYXKy3DjM/AM=
          =aXmh
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        trust = "ultimate";
      }
    ];
  };
  services.gpg-agent = {
    enableSshSupport = true;
    enableExtraSocket = true;
  };
}
