{pkgs, ...}: {
  celeste = pkgs.callPackage ./games/celeste.nix {};
  datutil = pkgs.callPackage ./emulation/datutil.nix {};
  driver-san-francisco = pkgs.callPackage ./games/driver-san-francisco.nix {};
  es-de = pkgs.callPackage ./emulation/es-de.nix {};
  es-de-bin = pkgs.callPackage ./emulation/es-de-bin.nix {};
  factorio-local = pkgs.callPackage ./games/factorio.nix {};
  liftoff = pkgs.callPackage ./games/liftoff.nix {};
  nfoview = pkgs.callPackage ./apps/nfoview.nix {};
  ryujinx = pkgs.callPackage ./emulation/ryujinx {};
  shadps4 = pkgs.callPackage ./emulation/shadps4.nix {};
  sudachi = pkgs.callPackage ./emulation/sudachi {};
  supermeatboy = pkgs.callPackage ./games/supermeatboy.nix {};
  uncrashed = pkgs.callPackage ./games/uncrashed.nix {};
  zen-browser = pkgs.callPackage ./apps/zen-browser.nix {};

  # factorio-space-age = pkgs.callPackage ./games/factorio-space-age.nix {};
  # the-crew = pkgs.callPackage ./games/the-crew.nix {};
}
