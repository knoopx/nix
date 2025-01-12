{lib, ...}: {
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
        filters = lib.strings.splitString "\n" (lib.readFile ./ublock.rules);

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
}
