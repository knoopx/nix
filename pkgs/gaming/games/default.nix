{pkgs, ...}: {
  brothers-a-tale-of-two-sons-remake = pkgs.callPackage ./games/brothers-a-tale-of-two-sons-remake.nix {};
  celeste = pkgs.callPackage ./games/celeste.nix {};
  driver-san-francisco = pkgs.callPackage ./games/driver-san-francisco.nix {};
  liftoff = pkgs.callPackage ./games/liftoff.nix {};
  supermeatboy = pkgs.callPackage ./games/supermeatboy.nix {};
  uncrashed = pkgs.callPackage ./games/uncrashed.nix {};
  worldofgoo = pkgs.callPackage ./games/worldofgoo.nix {};
}
