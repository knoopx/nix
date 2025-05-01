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
