{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "dataset-viewer";
  src = ./scripts/dataset-viewer.py;
  phases = ["installPhase"];
  installPhase = ''
    install -m 755 -D $src $out/bin/ds
  '';
}
