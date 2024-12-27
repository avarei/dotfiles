{ config, inputs, lib, pkgs, ... }:

let
  foo = "bar";
in {
  # Manages keys and such
  programs = {
    gnupg.agent = {
      enable = true;
      enableExtraSocket = true;
      enableSSHSupport = true; # Make GPG through SSH work
      # pinentryFlavor = "curses"; # Options: "curses", "tty", "gtk2", "qt"
    };
  };
}
