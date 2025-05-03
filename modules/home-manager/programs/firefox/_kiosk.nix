{
  pkgs,
  defaults,
  betterfox,
  ...
}: {
  isDefault = false;
  id = 99;

  extensions.packages = with pkgs.firefox-addons; [
    ublock-origin
    copy-selected-links
    sponsorblock
    dictionary-spanish
    brotab
  ];

  extraConfig = ''
    ${builtins.readFile "${betterfox}/user.js"}
    user_pref("urlclassifier.trackingSkipURLs", "embed.reddit.com, *.twitter.com, *.twimg.com");
    user_pref("urlclassifier.features.socialtracking.skipURLs", "*.twitter.com, *.twimg.com");
    user_pref("signon.rememberSignons", true);
    user_pref("extensions.formautofill.addresses.enabled", true);
    user_pref("extensions.formautofill.creditCards.enabled", true);
    user_pref("permissions.default.geo", 0);
    user_pref("permissions.default.desktop-notification", 0);
    user_pref("browser.search.suggest.enabled", true);
    user_pref("dom.webnotifications.requireuserinteraction", false);
    user_pref("permissions.default.desktop-notification", 1);
  '';

  userChrome = ''
    #TabsToolbar {
      visibility: collapse !important;
    }

    /* Hide address bar, back/forward, bookmarks */
    #nav-bar {
      visibility: collapse !important;
    }

    /* Hide bookmarks toolbar */
    #PersonalToolbar {
      visibility: collapse !important;
    }

    /* Hide sidebar (if open) */
    #sidebar-box {
      visibility: collapse !important;
    }

    /* Optional: hide menu bar (Linux) */
    #toolbar-menubar {
      visibility: collapse !important;
    }

    /* Optional: hide title bar */
    .titlebar-placeholder,
    #titlebar {
      display: none !important;
    }
  '';

  userContent = ''
    ${builtins.readFile "${pkgs.theming.mkUserStyles defaults.colorScheme.palette}"}
  '';
}
