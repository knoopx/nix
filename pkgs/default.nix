{
  inputs,
  pkgs,
  ...
}: {
  theming = pkgs.callPackage ./theming {inherit inputs pkgs;};
  nfoview = pkgs.callPackage ./apps/nfoview.nix {};
  citron-emu = pkgs.callPackage ./gaming/emulation/citron-emu.nix {};
  datutil = pkgs.callPackage ./gaming/emulation/datutil.nix {};
  es-de = pkgs.callPackage ./gaming/emulation/es-de.nix {};
  hydra-launcher = pkgs.callPackage ./gaming/emulation/hydra-launcher.nix {};
  ryujinx = pkgs.callPackage ./gaming/emulation/ryujinx {};
  shadps4 = pkgs.callPackage ./gaming/emulation/shadps4.nix {};
  skyscraper = pkgs.callPackage ./gaming/emulation/skyscraper.nix {};
  sudachi = pkgs.callPackage ./gaming/emulation/sudachi {};
  wiiudownloader = pkgs.callPackage ./gaming/emulation/wiiudownloader.nix {};
}
