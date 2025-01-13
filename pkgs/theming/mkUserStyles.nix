{
  pkgs,
  lib,
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
  ];

  userStylePkgs =
    (lib.map (x: pkgs.callPackage x {inherit colorScheme;}) userStyles)
    ++ [
      (pkgs.theming.mkCatppuccinUserStyleTheme colorScheme)
    ];
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "userstyles.css";
    phases = ["buildPhase"];
    buildInputs = with pkgs.nodePackages_latest; [
      postcss
      postcss-cli
      sass
    ];

    buildPhase = ''
      userStyles=(${lib.strings.escapeShellArgs userStylePkgs})
      userStyles=''${userStyles[@]}
      cat $userStyles | sass --quiet - >> userstyles.css
      postcss --no-map userstyles.css -u ${transform} -o $out
    '';
  }
