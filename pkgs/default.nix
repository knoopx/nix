{pkgs, ...} @ args: let
  apps = pkgs.callPackage ./apps args;
  emulation = pkgs.callPackage ./gaming/emulation args;
  theming = pkgs.callPackage ./theming args;
  scripts = pkgs.callPackage ./scripts args;
in {
  inherit theming;
  inherit (apps) nfoview ultralytics semantic-grep;
  inherit (emulation) es-de hydra-launcher ryujinx wiiudownloader;
  inherit (scripts) ollamark importantize;
}
