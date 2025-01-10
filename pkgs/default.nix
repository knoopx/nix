{pkgs, ...} @ args: let
  apps = pkgs.callPackage ./apps args;
  emulation = pkgs.callPackage ./gaming/emulation args;
  theming = pkgs.callPackage ./theming args;
  scripts = pkgs.callPackage ./scripts args;
in {
  inherit theming;
  inherit (apps) nfoview;
  inherit (emulation) es-de hydra-launcher citron-emu ryujinx;
  inherit (scripts) fuzzy webkit-shell shttp;
}
