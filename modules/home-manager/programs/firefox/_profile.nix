{
  pkgs,
  nixosConfig,
  betterfox,
  nix-userstyles,
  ...
}: let
  c = nixosConfig.defaults.colorScheme.palette;
  importantize = pkgs.callPackage "${nix-userstyles}/lib/importantize.nix" {};
  importantizeCss = name: css:
    builtins.readFile (pkgs.runCommandLocal name {
        passAsFile = ["css"];
        inherit css;
      } ''
        cat "$cssPath" | ${pkgs.lib.getExe importantize} > $out
      '');
  jumpAddonId = "jump@knoopx";
  jump = pkgs.stdenvNoCC.mkDerivation {
    pname = "jump";
    version = "0.2.4";
    src = pkgs.fetchurl {
      url = "https://github.com/knoopx/jump/releases/download/v0.2.4/jump-0.2.4.xpi";
      hash = "sha256-STEtISZEh0g6FYaJI7r4JFISy7ETxvLCCICbeGhwnAs=";
    };
    preferLocalBuild = true;
    allowSubstitutes = true;
    passthru = {
      addonId = jumpAddonId;
    };
    buildCommand = ''
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      cp "$src" "$dst/${jumpAddonId}.xpi"
    '';
    meta = {
      description = "Keyboard-driven link navigation with per-site selectors";
      homepage = "https://github.com/knoopx/jump";
      license = pkgs.lib.licenses.mit;
      platforms = pkgs.lib.platforms.all;
    };
  };

  base16Vars = builtins.concatStringsSep "\n" (
    map (key: "  --base${key}: #${c."base${key}"};")
    ["00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "0A" "0B" "0C" "0D" "0E" "0F"]
  );
  cssVarsBlock = selector: "${selector} {\n${base16Vars}\n  }";
  cssVars = cssVarsBlock ":root";
  devtoolsCssVars = cssVarsBlock ":root.theme-dark";
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
    ${builtins.readFile ./chrome/user.js}

  '';

  userChrome = ''
    ${cssVars}
    ${importantizeCss "userChrome" (builtins.readFile ./chrome/user.css)}
  '';

  userContent = ''
    ${cssVars}
    ${devtoolsCssVars}
    ${importantizeCss "userContent" (builtins.readFile ./chrome/content.css)}
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
    "xpinstall.signatures.required" = false;
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
