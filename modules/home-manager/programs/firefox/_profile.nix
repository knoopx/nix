{
  pkgs,
  nixosConfig,
  betterfox,
  nix-userstyles,
  ...
}: let
  c = nixosConfig.defaults.colorScheme.palette;
  jumpAddonId = "jump@knoopx.net";
  jump = pkgs.stdenvNoCC.mkDerivation {
    pname = "jump";
    version = "0.2.2";
    src = pkgs.fetchurl {
      url = "https://github.com/knoopx/jump/releases/download/v0.2.2/jump-0.2.2.xpi";
      hash = "sha256-Tyok1ilXAnIq3YisOZtGz+9BImkPztNTfg+ZJQRhWr0=";
    };
    nativeBuildInputs = [pkgs.zip pkgs.unzip pkgs.jq];
    preferLocalBuild = true;
    allowSubstitutes = true;
    passthru = {
      addonId = jumpAddonId;
    };
    buildCommand = ''
      workdir=$(mktemp -d)
      cd "$workdir"
      unzip "$src"
      jq '. + {browser_specific_settings: {gecko: {id: "${jumpAddonId}"}}}' manifest.json > manifest.json.tmp
      mv manifest.json.tmp manifest.json
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      zip -r "$dst/${jumpAddonId}.xpi" .
    '';
    meta = {
      description = "Keyboard-driven link navigation with per-site selectors";
      homepage = "https://github.com/knoopx/jump";
      license = pkgs.lib.licenses.mit;
      platforms = pkgs.lib.platforms.all;
    };
  };
in {
  id = 0;
  isDefault = true;

  extensions.packages = with pkgs.firefox-addons; [
    ublock-origin
    copy-selected-links
    sponsorblock
    dictionary-spanish
    brotab
    jump
  ];

  extraConfig = ''
    ${builtins.readFile "${betterfox}/user.js"}

    user_pref("apz.overscroll.enabled", true); // DEFAULT NON-LINUX
    user_pref("browser.fullscreen.autohide", true);
    user_pref("browser.link.open_newwindow.disabled_in_fullscreen", false);
    user_pref("browser.link.open_newwindow.external", 2);
    user_pref("browser.link.open_newwindow.restriction", 0);
    user_pref("browser.link.open_newwindow", 2);
    user_pref("browser.search.suggest.enabled", true);
    user_pref("browser.sessionstore.resume_session_once", true);
    user_pref("browser.tabs.closeWindowWithLastTab", true);
    user_pref("dom.disable_window_open_feature.location", false);
    user_pref("dom.disable_window_open_feature.menubar", false);
    user_pref("dom.disable_window_open_feature.minimizable", false);
    user_pref("dom.disable_window_open_feature.personalbar", false);
    user_pref("dom.disable_window_open_feature.resizable", false);
    user_pref("dom.disable_window_open_feature.status", false);
    user_pref("dom.disable_window_open_feature.toolbar", false);
    user_pref("extensions.formautofill.addresses.enabled", true);
    user_pref("extensions.formautofill.creditCards.enabled", true);
    user_pref("general.smoothScroll.currentVelocityWeighting", "0.15"); // default=.25
    user_pref("general.smoothScroll.mouseWheel.durationMinMS", 80); // default=50
    user_pref("general.smoothScroll.msdPhysics.enabled", false); // [FF122+ Nightly]
    user_pref("general.smoothScroll.stopDecelerationWeighting", "0.6"); // default=.4
    user_pref("general.smoothScroll", true); // DEFAULT
    user_pref("gnomeTheme.tabsAsHeaderbar", true);
    user_pref("mousewheel.min_line_scroll_amount", 10); // adjust this number to your liking; default=5
    user_pref("permissions.default.desktop-notification", 0);
    user_pref("permissions.default.desktop-notification", 1);
    user_pref("permissions.default.geo", 0);
    user_pref("signon.rememberSignons", true);
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("ui.systemUsesDarkTheme", 1);
  '';

  userChrome = ''
    /* Based on adolfgatonegro/firefox-minimal (Dook97/firefox-qutebrowser-userchrome) */
    :root {
      /* custom vars */
      --tab-active-bg: #${c.base02};
      --tab-inactive-bg: #${c.base00};
      --tab-active-fg: #${c.base05};
      --tab-inactive-fg: #${c.base04};
      --urlbar-height-setting: 32px;
      --tab-min-height: 28px !important;

      /* override firefox theme colors */
      --toolbox-bgcolor: #${c.base00} !important;
      --toolbox-bgcolor-inactive: #${c.base00} !important;
      --toolbox-textcolor: #${c.base05} !important;
      --toolbox-textcolor-inactive: #${c.base04} !important;
      --toolbar-bgcolor: #${c.base00} !important;
      --toolbar-color: #${c.base05} !important;
      --toolbar-field-background-color: #${c.base01} !important;
      --toolbar-field-focus-background-color: #${c.base01} !important;
      --toolbar-field-color: #${c.base05} !important;
      --toolbar-field-focus-color: #${c.base05} !important;
      --toolbar-field-border-color: transparent !important;
      --toolbar-field-focus-border-color: #${c.base08} !important;
      --focus-outline-color: #${c.base08} !important;
      --tab-selected-bgcolor: #${c.base02} !important;
      --tab-selected-textcolor: #${c.base05} !important;
      --tabs-navbar-separator-style: none !important;
      --tabs-navbar-separator-color: transparent !important;
      --lwt-accent-color: #${c.base00} !important;
      --lwt-text-color: #${c.base05} !important;
      --chrome-content-separator-color: transparent !important;
      --arrowpanel-background: #${c.base01} !important;
      --arrowpanel-color: #${c.base05} !important;
      --arrowpanel-border-color: #${c.base02} !important;
      --arrowpanel-border-radius: 8px !important;
      --urlbarView-highlight-background: #${c.base02} !important;
      --urlbarView-highlight-color: #${c.base05} !important;
      --urlbarView-hover-background: #${c.base01} !important;
      --sidebar-background-color: #${c.base00} !important;
      --sidebar-text-color: #${c.base05} !important;
      --sidebar-border-color: #${c.base02} !important;
    }

    /* --- NAVBAR: hidden, centered popover on Ctrl+L --- */

    /* Reset .browser-toolbar defaults that override our styles */
    #nav-bar {
      --urlbar-width: 100% !important;
      display: flex !important;
      flex-direction: column !important;
      appearance: none !important;
      border: none !important;
      background-color: #${c.base01} !important;
      background-image: none !important;
      color: #${c.base05} !important;
      position: fixed !important;
      top: -10000px !important;
      left: 50% !important;
      transform: translateX(-50%) !important;
      width: min(600px, 80vw) !important;
      max-width: 80vw !important;
      box-sizing: border-box !important;
      z-index: 10000 !important;
      outline: none !important;
      overflow: clip !important;
      border-radius: 12px !important;
      padding: 4px 12px !important;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5) !important;
    }
    #nav-bar:focus-within {
      top: 15% !important;
    }
    #navigator-toolbox:has(#nav-bar:focus-within) ~ #browser {
      opacity: 0.3 !important;
    }
    /* Force all nav-bar children to respect width */
    #nav-bar > * {
      max-width: 100% !important;
      min-width: 0 !important;
    }
    #nav-bar-customization-target {
      flex: 1 !important;
      min-width: 0 !important;
      max-width: 100% !important;
      overflow: hidden !important;
    }
    /* Kill urlbar breakout: Firefox sets --urlbar-width via JS and
     * uses position:absolute, which escapes our fixed-width nav-bar. */
    #urlbar-container {
      --urlbar-container-height: var(--urlbar-height-setting) !important;
      min-width: 0 !important;
      width: 100% !important;
      padding: 0 !important;
      margin: 0 !important;
    }
    #urlbar {
      --urlbar-height: var(--urlbar-height-setting) !important;
      --urlbar-toolbar-height: var(--urlbar-height-setting) !important;
      min-height: var(--urlbar-height-setting) !important;
      border: none !important;
      position: static !important;
      display: flex !important;
      flex-direction: column !important;
      width: 100% !important;
      max-width: 100% !important;
      height: auto !important;
      overflow: clip !important;
      margin: 0 !important;
    }
    #urlbar[breakout][breakout-extend] {
      width: 100% !important;
      margin: 0 !important;
      margin-left: 0 !important;
    }
    .urlbarView {
      background-color: transparent !important;
      border: none !important;
      outline: none !important;
      box-shadow: none !important;
      width: 100% !important;
      max-width: 100% !important;
      overflow: hidden !important;
    }
    .urlbarView-body-outer {
      max-height: 500px !important;
      overflow-x: hidden !important;
      overflow-y: auto !important;
    }
    .urlbarView-row {
      overflow: hidden !important;
    }
    .urlbarView-url, .urlbarView-title {
      overflow: hidden !important;
      text-overflow: ellipsis !important;
    }

    /* --- DEBLOAT NAVBAR --- */
    #back-button, #forward-button, #reload-button, #stop-button,
    #home-button, #library-button, #fxa-toolbar-menu-button,
    #PanelUI-menu-button,
    #customizableui-special-spring1, #customizableui-special-spring2,
    #star-button-box, #pocket-button, #urlbar-go-button,
    #identity-permission-box, #tracking-protection-icon-container,
    #reader-mode-button, #translations-button, #picture-in-picture-button,
    #unified-extensions-button, #urlbar-search-button, #searchbar,
    .titlebar-spacer, .titlebar-buttonbox-container, toolbarspring,
    #PersonalToolbar, #tabs-newtab-button,
    #scrollbutton-up, #scrollbutton-down,
    #private-browsing-indicator-with-label {
      display: none !important;
    }
    #urlbar .search-one-offs { display: none !important; }
    #userContext-label, #userContext-indicator { display: none !important; }

    /* --- URLBAR STYLE --- */
    #urlbar-background {
      border: 2px solid #${c.base08} !important;
      border-radius: 12px !important;
      outline: none !important;
      background: #${c.base01} !important;
      box-shadow: none !important;
    }
    [focused]:not([suppress-focus-border]) > .urlbar-background {
      outline: none !important;
      border: 2px solid #${c.base08} !important;
    }
    [open] > .urlbar-background {
      border: 2px solid #${c.base08} !important;
      background-color: #${c.base01} !important;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5) !important;
      border-radius: 12px !important;
    }
    #urlbar-input {
      color: #${c.base05} !important;
      text-align: left !important;
      font-size: 14px !important;
    }
    #urlbar .searchbar-engine-one-off-item,
    .search-panel-one-offs-header,
    .urlbar-search-mode-indicator {
      margin: 0 !important;
      padding: 0 2px !important;
    }

    /* --- TAB BAR (bottom) --- */
    #navigator-toolbox {
      border: none !important;
    }
    /* Move tabs below content */
    #titlebar {
      --proton-tab-block-margin: 0px !important;
      --tab-block-margin: 0px !important;
      -moz-box-ordinal-group: 100 !important;
      order: 100 !important;
    }
    #navigator-toolbox {
      -moz-box-ordinal-group: 100 !important;
      order: 100 !important;
    }
    #main-window #browser {
      -moz-box-ordinal-group: 0 !important;
      order: 0 !important;
    }
    #TabsToolbar, .tabbrowser-tab { max-height: var(--tab-min-height) !important; font-size: 11px !important; }

    /* hide tab bar with single tab */
    #tabbrowser-tabs:has(.tabbrowser-tab:only-of-type) {
      visibility: collapse !important;
    }
    #TabsToolbar:has(#tabbrowser-tabs .tabbrowser-tab:only-of-type) {
      visibility: collapse !important;
      max-height: 0 !important;
      min-height: 0 !important;
      height: 0 !important;
      padding: 0 !important;
      margin: 0 !important;
    }
    #tabbrowser-tabs, #tabbrowser-arrowscrollbox { min-height: var(--tab-min-height) !important; }
    #alltabs-button { display: none !important; }

    /* tab colors */
    tab:not([selected="true"]) {
      background-color: var(--tab-inactive-bg) !important;
      color: var(--identity-icon-color, var(--tab-inactive-fg)) !important;
    }
    tab:not([selected="true"]) .tab-background {
      background-color: var(--tab-inactive-bg) !important;
      background-image: none !important;
    }
    tab { font-weight: normal; border: none !important; }
    #tabbrowser-tabs .tabbrowser-tab[selected] .tab-content {
      background: var(--tab-active-bg) !important;
      color: var(--identity-icon-color, var(--tab-active-fg)) !important;
    }
    #tabbrowser-tabs .tabbrowser-tab:hover:not([selected]) .tab-content {
      background: var(--tab-active-bg) !important;
    }
    .tabbrowser-tab[fadein] { max-width: 100vw !important; border: none; }
    .tabbrowser-tab { flex: 0 1 auto !important; width: auto !important; }
    .tab-label { max-width: 200px !important; }
    .tabbrowser-tab {
      padding-inline: 0px !important;
      --tab-label-mask-size: 1em !important;
      overflow-clip-margin: 0px !important;
    }
    .tab-content {
      padding: 0 6px !important;
      align-items: center !important;
    }
    .tab-background {
      margin-block: 0 !important;
      min-height: var(--tab-min-height) !important;
    }
    #tabbrowser-tabs .tabbrowser-tab .tab-close-button { display: none !important; }
    #tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
      box-shadow: none !important;
    }
    #tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
      height: var(--tab-min-height) !important;
    }

    /* --- MISC --- */
    #fullscreen-warning { border: none !important; background: -moz-Dialog !important; }
    #statuspanel-label { border-radius: 0px !important; border: 0px !important; }
    menupopup, panel { --panel-border-radius: 0px !important; }
    menupopup > #context-navigation { display: none !important; }
    menupopup > #context-sep-navigation { display: none !important; }
  '';

  userContent = ''
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
