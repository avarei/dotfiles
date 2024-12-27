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

        mDMEZ2v2ghYJKwYBBAHaRw8BAQdA80yyJpj5FezYnxvk9MwyUZyitlyhXXUn+aac
        ZMlkiBu0NVRpbSBHZWltZXIgPDMyNTU2ODk1K0F2YXJlaUB1c2Vycy5ub3JlcGx5
        LmdpdGh1Yi5jb20+iJYEExYIAD4WIQRx0dpldShp/ODnSWNYflp4sialjwUCZ2v2
        ggIbAQUJA8JnAAULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRBYflp4sialj91i
        AQDhj95u77mmbf8ckkk1Zcfunm279v3QRMsWR/0iqFphZgEA48HaWqGL5MINo+Nh
        2u44DHbMuwRnIEccITlV6QPHzwC4MwRnbpXIFgkrBgEEAdpHDwEBB0CdKSXWWqme
        YS0vj0BMUSZTmaR4o/CyR9wXC+Wt2XfUXIj1BBgWCgAmFiEEcdHaZXUoafzg50lj
        WH5aeLImpY8FAmdulcgCGyIFCQPCZwAAgQkQWH5aeLImpY92IAQZFgoAHRYhBBkO
        a/YIoWVRLtCg/qQgSHFFN5F3BQJnbpXIAAoJEKQgSHFFN5F3R2gBANdhnH+ztwSp
        LIzLuOciHh/QotMJdPOzMdNehT5sNpbhAQClqOoC8FnTWIFnQqoPLG3CRzOZ16Au
        KjFQZEbeOBO1BoRRAQCcD43EH2HLD4vRwm9B4/G9EpgCPqUYEfCJ7sJzEM+8PAD/
        a0T6zIzi69eLrZLbg8yTmba+OUmVIBm2M47W5+m+rQ0=
        =EWmQ
        -----END PGP PUBLIC KEY BLOCK-----
      '';
      trust = "ultimate";}
    ];
  };
  # home.sessionVariables = {
  #   SSH_AUTH_SOCK = "$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)";
  # };

}
