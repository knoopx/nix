{ pkgs }:

pkgs.runCommand "session-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "session-control";
} ''
  mkdir -p $out/bin
  cp ${./session-control.nu} $out/bin/session-control.nu
  chmod +x $out/bin/session-control.nu
  makeWrapper $out/bin/session-control.nu $out/bin/session-control \
    --suffix PATH : ${pkgs.hyprlock}/bin:${pkgs.niri}/bin:${pkgs.nushell}/bin
''