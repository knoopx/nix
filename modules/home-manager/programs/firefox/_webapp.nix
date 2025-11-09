{
  pkgs,
  nixosConfig,
  betterfox,
  nix-userstyles,
  ...
}: let
  theme = pkgs.theming.mkStylixFirefoxGnomeTheme nixosConfig.defaults.colorScheme.palette;
in {
  id = 999;

  extraConfig = ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("browser.tabs.closeWindowWithLastTab", true);
    user_pref("browser.sessionstore.resume_session_once", true);
    user_pref("browser.fullscreen.autohide", true);
    user_pref("mod.sameerasw_zen_compact_sidebar_type", "0");
    user_pref("zen.view.compact.enable-at-startup", true);
    user_pref("zen.welcome-screen.seen", true);
    user_pref("zen.widget.linux.transparency", true);
    user_pref("ui.systemUsesDarkTheme", 1);
    user_pref("permissions.default.desktop-notification", 1);
  '';

  userChrome = ''
    #TabsToolbar,
    #nav-bar,
    #PersonalToolbar,
    #statuspanel,
    #sidebar-box {
      visibility: collapse !important;
    }
    #titlebar {
      visibility: collapse !important;
    }
    :root[sizemode="normal"] #toolbar-menubar {
      visibility: collapse !important;
    }
    #toolbar-menubar[autohide="false"] {
      visibility: visible !important;
    }
  '';
}
