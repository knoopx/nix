{
  pkgs,
  lib,
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
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "userstyles.css";
    phases = ["buildPhase"];
    buildInputs = with pkgs.nodePackages_latest; [
      sass
    ];

    buildPhase = ''
      userStyles=(${lib.strings.escapeShellArgs userStylePkgs})
      userStyles=''${userStyles[@]}
      (echo "${cssVars}" && cat $userStyles) | sass --quiet - >> userstyles.css
      cat userstyles.css | ${lib.getExe pkgs.importantize} > $out
    '';
  }
