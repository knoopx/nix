{pkgs, ...}: {
  nfoview = pkgs.callPackage ./nfoview.nix {};
  semantic-grep = pkgs.callPackage ./semantic-grep.nix {};
  ultralytics = pkgs.callPackage ./ultralytics.nix {};
  msty = pkgs.callPackage ./msty.nix {};
}
