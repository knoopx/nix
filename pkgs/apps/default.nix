{pkgs, ...}: {
  nfoview = pkgs.callPackage ./nfoview.nix {};
  semantic-grep = pkgs.callPackage ./semantic-grep.nix {};
}
