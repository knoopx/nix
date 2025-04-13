{
  pkgs,
  lib,
  ...
} @ inputs: colorScheme: let
  userStyles = [
    ./userstyles/telegram.nix
    ./userstyles/whatsapp.nix
    ./userstyles/immich.nix
    ./userstyles/claude.nix
    ./userstyles/devdocs.nix
  ];

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
