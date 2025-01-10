{pkgs, ...} @ args: {
  fuzzy = pkgs.callPackage ./fuzzy args;
  webkit-shell = pkgs.callPackage ./webkit-shell args;
  shttp = pkgs.callPackage ./shttp args;
}
