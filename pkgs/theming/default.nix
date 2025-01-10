{
  pkgs,
  inputs,
  ...
}: {
  lib = pkgs.callPackage ./lib {inherit inputs;};
  pattern-monster = pkgs.callPackage ./pattern-monster.nix {};

  mkUserStyles = pkgs.callPackage ./mkUserStyles.nix {};
  mkStylixFirefoxGnomeTheme = pkgs.callPackage ./mkStylixFirefoxGnomeTheme.nix {};
  mkStylixMemosPkg = pkgs.callPackage ./mkStylixMemosPkg.nix {};
  mkMoreWaitaTheme = pkgs.callPackage ./mkMoreWaitaTheme.nix {};
  mkSvgPatternWallpaper = pkgs.callPackage ./mkSvgPatternWallpaper.nix {};
}
