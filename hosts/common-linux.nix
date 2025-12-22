{config, ...}: {
  imports = [
    ./default.nix
    ../modules/nixos/gpg
  ];
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

  users.users.${config.dotfiles.user} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "docker"];
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
}
