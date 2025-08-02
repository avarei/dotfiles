{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
    ];
  };
  programs.firefox = {
    enable = true;
    profiles.tim = {
      isDefault = true;
      id = 0;
      search.default = "ddg";
    };
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };
    };
  };
}
