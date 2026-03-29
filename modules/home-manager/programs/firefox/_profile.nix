{
  pkgs,
  nixosConfig,
  betterfox,
  usercontent-css,
  ...
}: let
  c = nixosConfig.defaults.colorScheme.palette;
  system = pkgs.stdenv.hostPlatform.system;
  palette = builtins.mapAttrs (_: v: "#${v}") c;
  userStyles = usercontent-css.lib.${system}.mkUserStyles palette;
  uBlockRules = usercontent-css.lib.${system}.uBlockRules;
  jumpAddonId = "jump@knoopx";
  jump = pkgs.stdenvNoCC.mkDerivation {
    pname = "jump";
    version = "0.2.8";
    src = pkgs.fetchurl {
      url = "https://github.com/knoopx/jump/releases/download/v0.2.8/jump-0.2.8.xpi";
      hash = "sha256-mh9/bl/3yewHDllMetbAiPcrDtvm0c+cx3oarFN30UY=";
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
    ${builtins.readFile ./chrome/user.css}
  '';

  userContent = ''
    ${cssVars}
    ${devtoolsCssVars}
    ${builtins.readFile ./chrome/content.css}
    ${builtins.readFile userStyles}
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
}
