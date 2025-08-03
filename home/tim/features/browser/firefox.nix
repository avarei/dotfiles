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
      FirefoxHome = {
        SponsoredTopSites = false;
        Pocket = false;
        SponsoredPocket = false;
        SponsoredStories = false;
      };
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      PasswordManagerEnabled = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      SearchEngines.Add = [
        {
          Name = "Nix Packages";
          URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
          Method = "GET";
          IconURL = "https://search.nixos.org/favicon.png";
          Alias = "np";
          Description = "Nix Package Search";
        } {
          Name = "Nix Options";
          URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
          Method = "GET";
          IconURL = "https://search.nixos.org/favicon.png";
          Alias = "no";
          Description = "Nix Option Search";
        } {
          Name = "Home-Manager Options";
          URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
          Method = "GET";
          IconURL = "https://home-manager-options.extranix.com/images/favicon.png";
          Alias = "ho";
          Description = "Home-Manager Option Search";
        }
      ];

      Bookmarks = [
        {
          Title = "Duck AI";
          URL = "https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat";
          Placement = "toolbar";
          Favicon = "https://duckduckgo.com/favicon.ico";
        } {
          Title = "Github";
          URL = "https://github.com";
          Placement = "toolbar";
          Favicon = "https://github.githubassets.com/favicons/favicon-dark.svg";
        }
      ];
    };
  };
}
