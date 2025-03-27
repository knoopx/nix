{
  pkgs,
  lib,
  fetchurl,
  ...
}: colorScheme: let
  transform = pkgs.writeTextFile {
    name = "userstyles-transform.js";
    text = ''
      module.exports = (options = {}) => {
        return (css) => {
          css.walkDecls((decl) => {
            decl.important = true;
          });
        };
      };
    '';
  };

  userStyles = [
    ./userstyles/telegram.nix
    ./userstyles/whatsapp.nix
    ./userstyles/immich.nix
    ./userstyles/claude.nix
    ./userstyles/devdocs.nix
  ];

  userStylePkgs =
    (lib.map (x: pkgs.callPackage x {inherit colorScheme;}) userStyles)
    ++ [
      (pkgs.theming.mkCatppuccinUserStyleTheme colorScheme)
    ];

  cssVars = ''
    :root {
    ${
      builtins.concatStringsSep "\n" (lib.attrsets.mapAttrsToList (
          name: value: "--${name}: #${toString value};"
        )
        colorScheme)
    }
    }
  '';
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "userstyles.css";
    phases = ["buildPhase"];
    buildInputs = with pkgs.nodePackages_latest; [
      (
        postcss-cli.override (oldAttrs: {
          dependencies = builtins.map (x:
            if x.packageName == "@esbuild/linux-x64"
            then
              (x
                // {
                  src = fetchurl {
                    url = "https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-${x.version}.tgz";
                    sha512 = "sha512-xbfUhu/gnvSEg+EGovRc+kjBAkrvtk38RlerAzQxvMzlB4fXpCFCeUAYzJvrnhFtdeyVCDANSjJvOvGYoeKzFA==";
                  };
                })
            else x)
          oldAttrs.dependencies;
        })
      )
      sass
    ];

    buildPhase = ''
      userStyles=(${lib.strings.escapeShellArgs userStylePkgs})
      userStyles=''${userStyles[@]}
      (echo "${cssVars}" && cat $userStyles) | sass --quiet - >> userstyles.css
      postcss --no-map userstyles.css -u ${transform} -o $out
    '';
  }
