{pkgs, ...} @ args: {
  style,
  colors,
  scale ? 1,
}: let
  mkSVGPatternCSS = pkgs.callPackage ./mkSVGPatternCSS.nix args;
in
  pkgs.writeTextFile {
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
  }
