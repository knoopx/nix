{ pkgs }:

pkgs.runCommand "display-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "display-control";
} ''
  mkdir -p $out/bin
  cp ${./display-control.nu} $out/bin/display-control.nu
  chmod +x $out/bin/display-control.nu
  makeWrapper $out/bin/display-control.nu $out/bin/display-control \
    --suffix PATH : ${pkgs.niri}/bin:${pkgs.nushell}/bin
''