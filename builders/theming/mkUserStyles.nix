{
  pkgs,
  lib,
  defaults,
  nix-colors,
  catppuccin-userstyles,
  ...
} @ inputs: colorScheme: let
  recursiveNixModules = import ../../lib/listNixModulesRecusive.nix inputs;
  userStyles = recursiveNixModules ./userstyles;

  mkCatppuccinUserStyleTheme = pkgs.callPackage ./mkCatppuccinUserStyleTheme.nix inputs;

  userStylePkgs =
    (lib.map (x: pkgs.callPackage x {inherit colorScheme;}) userStyles)
    ++ [
      (mkCatppuccinUserStyleTheme colorScheme)
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

  catppuccinMochaPalette = lib.attrValues nix-colors.colorSchemes.catppuccin-mocha.palette;
  palette = lib.attrValues colorScheme;
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "userstyles.css";
    phases = ["buildPhase"];
    buildInputs = [
      pkgs.nodePackages_latest.sass
      pkgs.lutgen
    ];
    buildPhase = ''
      userStyles=(${lib.strings.escapeShellArgs userStylePkgs})
      userStyles=''${userStyles[@]}
      (echo "${cssVars}" && cat $userStyles) | sass --quiet - >> userstyles.css

      substituteInPlace userstyles.css \
        ${lib.concatStringsSep " \\\n        " (lib.zipListsWith (
          mochaColor: paletteColor: "--replace-warn '${mochaColor}' '${paletteColor}'"
        )
        catppuccinMochaPalette
        palette)}

      cat userstyles.css | ${lib.getExe pkgs.importantize} > $out
    '';
  }
