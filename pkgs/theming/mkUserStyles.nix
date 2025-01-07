{pkgs, ...}: colorScheme: let
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
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "userstyles";
    phases = ["buildPhase"];
    buildInputs = with pkgs.nodePackages_latest; [
      postcss
      postcss-cli
    ];
    buildPhase = ''
      cat ${catppuccin} >> userstyles.css
      cat ${telegram} >> userstyles.css
      cat ${whatsapp} >> userstyles.css
      postcss userstyles.css -u ${transform} -o $out
    '';
  }
