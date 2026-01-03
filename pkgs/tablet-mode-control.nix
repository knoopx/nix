{ pkgs }:

pkgs.runCommand "tablet-mode-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "tablet-mode-control";
} ''
  mkdir -p $out/bin
  cp ${./tablet-mode-control.nu} $out/bin/tablet-mode-control.nu
  chmod +x $out/bin/tablet-mode-control.nu
  makeWrapper $out/bin/tablet-mode-control.nu $out/bin/tablet-mode-control \
    --suffix PATH : ${pkgs.glib}/bin
''
