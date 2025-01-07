{
  defaults,
  pkgs,
  config,
  lib,
  ...
}: let
  profile = defaults.username;
  theme = pkgs.mkStylixFirefoxGnomeTheme defaults.colorScheme.palette;
in {
  imports = [
    # ./firefox-homepage
    ./glance
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
      HardwareAcceleration = true;
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      DontCheckDefaultBrowser = true;
      DisableSetDesktopBackground = true;

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };

      DisableAppUpdate = true;
      OverrideFirstRunPage = "";
      PictureInPicture.Enabled = false;
      PromptForDownloadLocation = false;
      Preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.tabs.loadInBackground" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.warnOnQuitShortcut" = false;
      };
      PopupBlocking = {
        Default = false;
        Locked = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      "3rdparty".Extensions = {
        # https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
        "uBlock0@raymondhill.net" = {
          userSettings = [
            ["advancedUserEnabled" "true"]
            ["autoUpdate" "true"]
            ["contextMenuEnabled" "true"]
            ["dynamicFilteringEnabled" "true"]
          ];
          toOverwrite = {
            filters = lib.strings.splitString "\n" ''
              chatgpt.com##.absolute:has-text("Thanks for trying")
              chatgpt.com##body:style(pointer-events: auto !important)
              youtube.com##div[class^='YtInlinePlayerControlsTopLeftControls']
              youtube.com##div[class^='ytp-paid-content-overlay']
              youtube.com##a[href="https://support.google.com/youtube?p=ppp&nohelpkit=1"]
            '';

            filterLists = [
              "adguard-cookiemonster"
              "adguard-cookies"
              "adguard-mobile-app-banners"
              "adguard-other-annoyances"
              "adguard-popup-overlays"
              "adguard-widgets"
              "dpollock-0"
              "easylist-annoyances"
              "easylist-chat"
              "easylist-newsletters"
              "easylist-notifications"
              "easylist"
              "easyprivacy"
              "fanboy-cookiemonster"
              "plowe-0"
              "ublock-abuse"
              "ublock-annoyances"
              "ublock-badware"
              "ublock-cookies-adguard"
              "ublock-cookies-easylist"
              "ublock-filters"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "urlhaus-1"
              "user-filters"
              "easyprivacy"
              "adguard-spyware"
              "adguard-spyware-url"
              "block-lan"
              "easylist"
              "adguard-generic"
              "adguard-mobile"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-abuse"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "ublock-badlists"
              "https://raw.githubusercontent.com/liamengland1/miscfilters/master/antipaywall.txt"
              "https://raw.githubusercontent.com/gijsdev/ublock-hide-yt-shorts/master/list.txt"
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
            ];
          };
        };
      };
    };

    profiles.${profile} = {
      isDefault = true;
      extensions = with pkgs.firefox-addons; [
        ublock-origin
        copy-selected-links
        hover-zoom-plus
        sponsorblock
        web-archives
        clearurls
      ];

      settings = {
        "browser.startup.homepage" = "http://${config.services.glance.settings.server.host}:${builtins.toString config.services.glance.settings.server.port}";
        # "browser.startup.homepage" = "file://${config.firefox-homepage.path}";

        "browser.newtabpage.pinned" = [
          {
            title = "NixOS";
            url = "https://nixos.org";
          }
        ];

        # "sidebar.verticalTabs" = false;
        # "sidebar.main.tools" = "";
        # "sidebar.visibility" = "hidden";

        # "browser.startup.blankWindow" = false;
        # "layout.css.has-selector.enabled" = true;
        # "browser.toolbars.bookmarks.visibility" = "never";
        "widget.gtk.rounded-bottom-corners.enabled" = true;

        # "browser.tabs.drawInTitlebar" = true;
        "browser.newtabpage.enhanced" = true;
        # "ui.systemUsesDarkTheme" = 2;

        "browser.newtab.privateAllowed" = true;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "devtools.chrome.enabled" = true;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "dom.security.https_first" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "browser.newtab.preload" = true;

        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.closeWindowWithLastTab" = true;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "extensions.autoDisableScopes" = 0;
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
      };
      extraConfig = builtins.readFile "${theme}/configuration/user.js";

      userChrome = ''
        @import "${theme}/userChrome.css";
      '';

      userContent = ''
        @import "${theme}/userContent.css";
        ${builtins.readFile "${pkgs.mkUserStyles defaults.colorScheme.palette}"}
      '';
    };
  };
}
