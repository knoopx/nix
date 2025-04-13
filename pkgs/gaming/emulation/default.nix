{pkgs, ...}: {
  datutil = pkgs.callPackage ./datutil.nix {};
  es-de = pkgs.callPackage ./es-de.nix {};
}
