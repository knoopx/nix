{
  pkgs,
  nixosConfig,
  betterfox,
  nix-userstyles,
  ...
}: let
  theme = pkgs.theming.mkStylixFirefoxGnomeTheme nixosConfig.defaults.colorScheme.palette;
in {
  id = 0;
  isDefault = true;

  extensions.packages = with pkgs.firefox-addons; [
    ublock-origin
    copy-selected-links
    sponsorblock
    dictionary-spanish
    brotab
  ];

  extraConfig = ''
    ${builtins.readFile "${theme}/configuration/user.js"}
    ${builtins.readFile "${betterfox}/user.js"}

    user_pref("dom.disable_window_open_feature.location", false);
    user_pref("dom.disable_window_open_feature.menubar", false);
    user_pref("dom.disable_window_open_feature.minimizable", false);
    user_pref("dom.disable_window_open_feature.personalbar", false);
    user_pref("dom.disable_window_open_feature.resizable", false);
    user_pref("dom.disable_window_open_feature.status", false);
    user_pref("dom.disable_window_open_feature.toolbar", false);

    user_pref("browser.link.open_newwindow", 2);
    user_pref("browser.link.open_newwindow.external", 2);
    user_pref("browser.link.open_newwindow.restriction", 0);
    user_pref("browser.link.open_newwindow.disabled_in_fullscreen", false);
    user_pref("gnomeTheme.tabsAsHeaderbar", true);

    user_pref("urlclassifier.trackingSkipURLs", "embed.reddit.com, *.twitter.com, *.twimg.com");
    user_pref("urlclassifier.features.socialtracking.skipURLs", "*.twitter.com, *.twimg.com");
    user_pref("signon.rememberSignons", true);
    user_pref("extensions.formautofill.addresses.enabled", true);
    user_pref("extensions.formautofill.creditCards.enabled", true);
    user_pref("permissions.default.geo", 0);
    user_pref("permissions.default.desktop-notification", 0);
    user_pref("browser.search.suggest.enabled", true);

    user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
    user_pref("general.smoothScroll", true); // DEFAULT
    user_pref("mousewheel.min_line_scroll_amount", 10); // adjust this number to your liking; default=5
    user_pref("general.smoothScroll.mouseWheel.durationMinMS", 80); // default=50
    user_pref("general.smoothScroll.currentVelocityWeighting", "0.15"); // default=.25
    user_pref("general.smoothScroll.stopDecelerationWeighting", "0.6"); // default=.4
    user_pref("general.smoothScroll.msdPhysics.enabled", false); // [FF122+ Nightly]
  '';

  userChrome = ''
    @import "${theme}/theme/gnome-theme.css"
  '';

  userContent = ''
    @import "${theme}/theme/userContent.css";
    ${builtins.readFile "${nix-userstyles.packages.${pkgs.stdenv.hostPlatform.system}.mkUserStyles nixosConfig.defaults.colorScheme.palette [
      "brave-search"
      "bsky"
      "chatgpt"
      "cinny"
      "claude"
      "devdocs"
      "discord"
      "duckduckgo"
      "github"
      "google"
      "hacker-news"
      "lobste.rs"
      "nixos-*"
      "npm"
      "ollama"
      "perplexity"
      "qwant"
      "reddit"
      "slack"
      "spotify-web"
      "stack-overflow"
      "telegram"
      "whatsapp-web"
      "wikipedia"
      "wikipedia"
      "youtube"
    ]}"}
  '';

  search = {
    default = "qwant";
    force = true;
    engines = {
      "home-manager" = {
        definedAliases = ["@hm"];
        urls = [
          {
            template = "https://home-manager-options.extranix.com/";
            params = [
              {
                name = "release";
                value = "master";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "nixpkgs" = {
        definedAliases = ["@nixpkgs"];
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "channel";
                value = "unstable";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Github" = {
        definedAliases = ["@gh"];
        urls = [
          {
            template = "https://github.com/search";
            params = [
              {
                name = "type";
                value = "code";
              }
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Noogle" = {
        definedAliases = ["@nix"];
        urls = [
          {
            template = "https://noogle.dev/q";
            params = [
              {
                name = "term";
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
      "qwant".metaData.hidden = false;
    };
  };

  settings = {
    "browser.link.open_newwindow.disabled_in_fullscreen" = false;
    "browser.link.open_newwindow.external" = 2;
    "browser.link.open_newwindow.restriction" = 0;
    "browser.link.open_newwindow" = 2;
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
    "sidebar.animation.enabled" = false;
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
