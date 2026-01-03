{ pkgs }:

pkgs.runCommand "window-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "window-control";
} ''
  mkdir -p $out/bin
  cp ${./window-control.nu} $out/bin/window-control.nu
  chmod +x $out/bin/window-control.nu
  makeWrapper $out/bin/window-control.nu $out/bin/window-control \
    --suffix PATH : ${pkgs.niri}/bin:${pkgs.nushell}/bin
''
