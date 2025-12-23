{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../shared/stylix.nix
    ./gui/niri.nix
    ./gaming/steam.nix
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
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "docker"];
    };

    console.keyMap = "us";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
      options = "shift:breaks_caps";
    };

    security.pam.services = {
      # allow FIDO2 login
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    security.pam.u2f.settings = {
      pinverification = 1;
      userpresence = 1;
    };
  };
}
