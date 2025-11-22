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

      search = {
        default = "ddg";
        force = true;
        engines = {
          nix-packages = {
            name = "Nix Packages";
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          home-manager-options = {
            name = "Home-Manager Options";
            urls = [{
              template = "https://home-manager-options.extranix.com";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://home-manager-options.extranix.com/images/favicon.png";
            definedAliases = [ "@ho" ];
          };

          bing.metaData.hidden = true;
          ecosia.metaData.hidden = true;
        };
      };
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
