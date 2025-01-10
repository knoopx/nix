{
  inputs,
  pkgs,
} @ args: rec {
  hexToRGB = inputs.nix-colors.lib.conversions.hexToRGB;
  hexToDec = inputs.nix-colors.lib.conversions.hexToDec;
  rgbToHex = pkgs.callPackage ./rgbToHex.nix args;
  hexToHSL = pkgs.callPackage ./hexToHSL.nix {inherit hexToDec;};
  colorVariations = pkgs.callPackage ./colorVariations.nix {inherit hexToRGB rgbToHex;};
  svgPatternCSS = pkgs.callPackage ./svgPatternCSS.nix args;
}
