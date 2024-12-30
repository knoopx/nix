{
  defaults,
  config,
  pkgs,
  ...
}: let
  catppuccin-userstyles = pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin-userstyles";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "userstyles";
      rev = "958476784e42e7562d6ed527b6a48cf8620752ce";
      sha256 = "sha256-1HkIURfa+dkrKb8jF9U6fM+EsjuyulAAN0/Gxhumito=";
    };
    buildPhase = ''
      mkdir -p $out
      for file in styles/*/*.user.less; do
        echo $file;
        (echo "@lightFlavor: 'mocha'; @darkFlavor: 'mocha'; @accentColor: 'rosewater'; @contrastColor: @accentColor; @highlightColor: @accentColor; @graphUseAccentColor: 1; @bg-opacity: 0.2; @bg-blur: 20px; @zen: 0; @styleVideoPlayer: 1; @stylePieces: 1; @hideProfilePictures: 0; @additions: 0;@urls: 'localhost'; @darkenShadows: 1; @colorizeLogo: 0; @lighterMessages: 0; @highlight-redirect: 0; @logo: 1; @oled: 0;" && cat $file) | ${pkgs.nodePackages_latest.less}/lib/node_modules/.bin/lessc -x - >> $out/userstyles.css
      done
    '';
  };

  # https://github.com/rafaelmardojai/firefox-theme-gnome/
  firefox-theme-gnome = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-theme-gnome";
    rev = "097c98cb4a7568f6f83a43e37950c08b575dd126";
    sha256 = "sha256-U9WjPisByrvw8Kt6Ufg9kLrvg7uHPsFSyG93GR3I1iE=";
  };

  firefox-theme-gnome-stylix = pkgs.stdenvNoCC.mkDerivation {
    name = "firefox-theme-gnome-stylix";
    src = firefox-theme-gnome;
    # home.file.".themes/${config.gtk.theme.name}".source
    # theme/colors/dark.css

    buildPhase = with defaults.colorScheme.palette; ''
      replacements=(
          "s/--gnome-accent:.*\$/--gnome-accent: #${base0D};/"
          "s/--gnome-accent-bg:.*\$/--gnome-accent-bg: #${base0D};/"
          "s/--gnome-window-background:.*\$/--gnome-window-background: #${base00};/"
          "s/--gnome-window-color:.*\$/--gnome-window-color: #${base05};/"
          "s/--gnome-view-background:.*\$/--gnome-view-background: #${base00};/"
          "s/--gnome-sidebar-background:.*\$/--gnome-sidebar-background: #${base01};/"
          "s/--gnome-secondary-sidebar-background:.*\$/--gnome-secondary-sidebar-background: #${base01};/"
          "s/--gnome-card-background:.*\$/--gnome-card-background: #${base01};/"
          "s/--gnome-menu-background:.*\$/--gnome-menu-background: #${base01};/"
          "s/--gnome-headerbar-background:.*\$/--gnome-headerbar-background: #${base01};/"
          "s/--gnome-toolbar-icon-fill:.*\$/--gnome-toolbar-icon-fill: #${base05};/"
          "s/--gnome-tabbar-tab-hover-background:.*\$/--gnome-tabbar-tab-hover-background: #${base02};/"
          "s/--gnome-tabbar-tab-active-background:.*\$/--gnome-tabbar-tab-active-background: #${base03};/"
          "s/--gnome-tabbar-tab-active-background-contrast:.*\$/--gnome-tabbar-tab-active-background-contrast: #${base03};/"
          "s/--gnome-tabbar-tab-active-hover-background:.*\$/--gnome-tabbar-tab-active-hover-background: #${base02};/"
          "s/--gnome-tabbar-identity-color-green:.*\$/--gnome-tabbar-identity-color-green: #${base0B};/"
          "s/--gnome-tabbar-identity-color-yellow:.*\$/--gnome-tabbar-identity-color-yellow: #${base0A};/"
          "s/--gnome-tabbar-identity-color-orange:.*\$/--gnome-tabbar-identity-color-orange: #${base09};/"
          "s/--gnome-tabbar-identity-color-red:.*\$/--gnome-tabbar-identity-color-red: #${base08};/"
          "s/--gnome-tabbar-identity-color-purple:.*\$/--gnome-tabbar-identity-color-purple: #${base0E};/"
      )

      for file in theme/colors/*.css; do
          for replace in "''${replacements[@]}"; do
              echo "Applying replacement: $replace"
              sed -i "$replace" "$file"
          done
      done
    '';

    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };

  profile = defaults.username;
in {
  # home.file.".mozilla/firefox/${config.programs.firefox.profiles.${profile}.path}/chrome".source = "${firefox-theme-gnome-stylix}";

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
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
    };

    profiles.${profile} = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };
      extraConfig = builtins.readFile "${firefox-theme-gnome-stylix}/configuration/user.js";

      userChrome = ''
        @import "${firefox-theme-gnome-stylix}/userChrome.css";
      '';

      userContent = ''
        @import "${firefox-theme-gnome-stylix}/userContent.css;
        ${builtins.readFile "${catppuccin-userstyles}/userstyles.css"}
      '';
    };
  };
}
