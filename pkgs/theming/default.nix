{
  inputs,
  pkgs,
}: rec {
  hexToRGB = inputs.nix-colors.lib.conversions.hexToRGB;
  hexToDec = inputs.nix-colors.lib.conversions.hexToDec;
  rgbToHex = pkgs.callPackage ./rgbToHex.nix {};
  hexToHSL = pkgs.callPackage ./hexToHSL.nix {inherit hexToDec;};
  colorVariations = pkgs.callPackage ./colorVariations.nix {inherit hexToRGB rgbToHex;};
  mkUserStyles = pkgs.callPackage ./mkUserStyles.nix {};
  mkStylixFirefoxGnomeTheme = pkgs.callPackage ./mkStylixFirefoxGnomeTheme.nix {};
  mkStylixMemosPkg = pkgs.callPackage ./mkStylixMemosPkg.nix {};
  mkMoreWaitaTheme = pkgs.callPackage ./mkMoreWaitaTheme.nix {};
}
