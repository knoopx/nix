{
  defaults,
  pkgs,
  ...
}: let
  profile = defaults.username;
  theme = pkgs.mkStylixFirefoxGnomeTheme defaults.colorScheme.palette;
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      FirefoxHome = {
        Pocket = false;
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
    };

    profiles.${profile} = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };
      extraConfig = builtins.readFile "${theme}/configuration/user.js";

      userChrome = ''
        @import "${theme}/userChrome.css";
      '';

      userContent = ''
        @import "${theme}/userContent.css";
        ${builtins.readFile "${pkgs.catppuccin-userstyles}/userstyles.css"}
      '';
    };
  };
}
