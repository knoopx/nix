{
  pkgs,
  inputs,
  defaults,
  ...
}: {
  lib = pkgs.callPackage ./lib {inherit inputs;};
  pattern-monster = pkgs.callPackage ./pattern-monster.nix {};
  dharmx-wallpapers = pkgs.callPackage ./dharmx-wallpapers.nix {};
  matchThemeColors = pkgs.callPackage ./matchThemeColors.nix {inherit defaults;};
  mkUserStyles = pkgs.callPackage ./mkUserStyles.nix {};
  mkCatppuccinUserStyleTheme = pkgs.callPackage ./mkCatppuccinUserStyleTheme.nix {inherit inputs;};
  mkStylixFirefoxGnomeTheme = pkgs.callPackage ./mkStylixFirefoxGnomeTheme.nix {};
  mkStylixMemosPkg = pkgs.callPackage ./mkStylixMemosPkg.nix {};
  mkMoreWaitaTheme = pkgs.callPackage ./mkMoreWaitaTheme.nix {};
  mkSvgPatternWallpaper = pkgs.callPackage ./mkSvgPatternWallpaper.nix {};
  mkGnomeShellTheme = pkgs.callPackage ./mkGnomeShellTheme.nix {};
}
