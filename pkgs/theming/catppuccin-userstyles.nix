{
  pkgs,
  lib,
  ...
}: let
  transform = pkgs.writeTextFile {
    name = "catppuccin-userstyles-postcss-transform.js";
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

  vars = {
    lightFlavor = "mocha";
    darkFlavor = "mocha";
    accentColor = "rosewater";
    contrastColor = "@accentColor";
    highlightColor = "@accentColor";
    graphUseAccentColor = 1;
    bg-opacity = 0.2;
    bg-blur = "20px";
    zen = 0;
    styleVideoPlayer = 1;
    stylePieces = 1;
    hideProfilePictures = 0;
    additions = 0;
    urls = "localhost";
    darkenShadows = 1;
    colorizeLogo = 0;
    lighterMessages = 0;
    highlight-redirect = 0;
    logo = 1;
    oled = 0;
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin-userstyles";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "userstyles";
      rev = "958476784e42e7562d6ed527b6a48cf8620752ce";
      sha256 = "sha256-1HkIURfa+dkrKb8jF9U6fM+EsjuyulAAN0/Gxhumito=";
    };
    buildInputs = with pkgs.nodePackages_latest; [
      postcss
      postcss-cli
      less
    ];
    buildPhase = ''
      for file in styles/{google,github,youtube,wikipedia,duckduckgo,nixos-*,chatgpt,npm,ollama,spotify-web}/catppuccin.user.less; do
        (echo "${lib.strings.concatMapStrings (x: ";" + x) (lib.attrsets.mapAttrsToList (k: v: "@${k}: ${toString v};") vars)}" && cat $file) | ${pkgs.nodePackages_latest.less}/lib/node_modules/.bin/lessc - >> userstyles.css
      done

      mkdir -p $out
      substituteInPlace userstyles.css --replace-fail "Unsupported GitHub theme detected! Please switch to the default light/dark theme via the GitHub Appearance settings to get the best experience for the Catppuccin GitHub userstyle." ""
      postcss userstyles.css -u ${transform} -o $out/userstyles.css
    '';
  }
