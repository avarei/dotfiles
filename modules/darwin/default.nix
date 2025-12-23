{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../stylix.nix
  ];

  options.dotfiles = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "tim";
    };
    ssh.publicKey = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = lib.splitString "\n" (builtins.readFile ../home/ssh.pub);
    };
  };
  config = {
    environment = {
      # for zsh completion of system packages
      pathsToLink = ["/share/zsh"];

      shells = [
        pkgs.bashInteractive
        pkgs.zsh
        pkgs.nushell
      ];
      systemPackages = [
        pkgs.direnv
      ];
    };

    time.timeZone = "Europe/Berlin";

    programs.zsh.enable = true;

    nix = {
      enable = true;
      package = pkgs.nix;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        allowed-users = [config.dotfiles.user];
        trusted-users = ["@wheel" config.dotfiles.user];
      };
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.dotfiles.user} = {
      description = config.dotfiles.user;
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = config.dotfiles.ssh.publicKey;
      packages = [pkgs.home-manager];
    };
  };
}
