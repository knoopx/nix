{
  pkgs,
  lib,
  defaults,
  ...
} @ args: {
  style,
  colors,
  scale ? 1,
}: let
  mkSVGPatternCSS = pkgs.callPackage ./mkSVGPatternCSS.nix args;
  html = pkgs.writeTextFile {
    name = "wallpaper.html";
    text = ''
      <!DOCTYPE html><html><head><style>body {
      ${
        mkSVGPatternCSS {
          inherit (style) width height path mode;
          inherit scale colors;
        }
      }
      }</style></head><body></body></html>
    '';
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    name = "wallpaper.png";
    phases = ["installPhase"];
    installPhase = ''
      export HOME=$(pwd)
      ${lib.getExe pkgs.firefox} -headless -screenshot --window-size ${toString defaults.display.width},${toString defaults.display.height} "file://${html}"
      mv screenshot.png $out
    '';
  }
