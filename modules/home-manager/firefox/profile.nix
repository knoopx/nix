{
  pkgs,
  config,
  defaults,
  ...
}: let
  theme = pkgs.theming.mkStylixFirefoxGnomeTheme defaults.colorScheme.palette;
in {
  isDefault = true;
  extensions.packages = with pkgs.firefox-addons; [
    ublock-origin
    copy-selected-links
    sponsorblock
    # hover-zoom-plus
    # web-archives
    # clearurls
  ];

  extraConfig = builtins.readFile "${theme}/configuration/user.js";

  userChrome = ''
    @import "${theme}/userChrome.css";
  '';

  userContent = ''
    @import "${theme}/userContent.css";
    ${builtins.readFile "${pkgs.theming.mkUserStyles defaults.colorScheme.palette}"}
  '';

  search = {
    default = "searxng";
    force = true;
    engines = {
      "searxng" = {
        # definedAliases = ["@sx"];
        urls = [
          {
            template = "http://search.knoopx.net";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "nixpkgs" = {
        # definedAliases = ["@nx"];
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "google".metaData.hidden = true;
      "ecosia".metaData.hidden = true;
      "ddg".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "amazondotcom-us".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "qwant".metaData.hidden = true;
    };
  };

  settings = {
    "browser.newtab.preload" = true;
    "browser.newtab.privateAllowed" = true;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.newtabpage.enabled" = false;
    "browser.newtabpage.enhanced" = true;
    "browser.ping-centre.telemetry" = false;
    "browser.startup.homepage" = "https://glance.knoopx.net";
    "browser.tabs.closeWindowWithLastTab" = true;
    "browser.urlbar.suggest.calculator" = true;
    "browser.urlbar.unitConversion.enabled" = true;
    "datareporting.healthreport.service.enabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.sessions.current.clean" = true;
    "devtools.chrome.enabled" = true;
    "devtools.onboarding.telemetry.logged" = false;
    "dom.security.https_first" = true;
    "extensions.autoDisableScopes" = 0;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "gfx.webrender.all" = true;
    "layers.acceleration.force-enabled" = true;
    "svg.context-properties.content.enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.hybridContent.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.prompted" = 2;
    "toolkit.telemetry.rejected" = true;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.server" = "";
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.unifiedIsOptIn" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "widget.gtk.rounded-bottom-corners.enabled" = true;
  };
}
