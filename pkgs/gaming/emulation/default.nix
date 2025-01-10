{pkgs, ...}: {
  citron-emu = pkgs.callPackage ./citron-emu.nix {};
  datutil = pkgs.callPackage ./datutil.nix {};
  es-de = pkgs.callPackage ./es-de.nix {};
  hydra-launcher = pkgs.callPackage ./hydra-launcher.nix {};
  ryujinx = pkgs.callPackage ./ryujinx {};
  shadps4 = pkgs.callPackage ./shadps4.nix {};
  skyscraper = pkgs.callPackage ./skyscraper.nix {};
  sudachi = pkgs.callPackage ./sudachi {};
  wiiudownloader = pkgs.callPackage ./wiiudownloader.nix {};
}
