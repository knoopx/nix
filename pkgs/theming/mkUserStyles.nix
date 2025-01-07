{
  pkgs,
  lib,
  ...
}: colorScheme: let
  telegram = pkgs.callPackage ./userstyles/telegram.nix {inherit colorScheme;};
  whatsapp = pkgs.callPackage ./userstyles/whatsapp.nix {};
  catppuccin = pkgs.callPackage ./userstyles/catppuccin.nix {};

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
    telegram
    whatsapp
  ];
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "userstyles.css";
    phases = ["buildPhase"];
    buildInputs = with pkgs.nodePackages_latest; [
      postcss
      postcss-cli
      less
    ];

    buildPhase = ''
      userStyles=(${lib.strings.escapeShellArgs userStyles})
      userStyles=''${userStyles[@]}
      # TODO: find some css checker
      cat $userStyles | lessc - >> userstyles.css
      cat ${catppuccin} >> userstyles.css
      postcss --no-map userstyles.css -u ${transform} -o $out
    '';
  }
