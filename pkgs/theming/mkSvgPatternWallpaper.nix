{pkgs, ...}: {
  style,
  colors,
  scale ? 1,
}:
pkgs.writeTextFile {
  name = "wallpaper.html";
  text = ''
    <!DOCTYPE html><html><head><style>body {
    ${
      pkgs.theming.lib.svgPatternCSS {
        inherit (style) width height path mode;
        inherit scale colors;
      }
    }
    }</style></head><body></body></html>
  '';
}
