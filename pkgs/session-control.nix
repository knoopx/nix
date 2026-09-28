{pkgs}:
pkgs.runCommand "session-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nushell pkgs.hyprlock pkgs.niri pkgs.systemd];
  meta.mainProgram = "session-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/session-control \
    --add-flags ${./session-control.nu} \
    --suffix PATH : ${pkgs.hyprlock}/bin:${pkgs.niri}/bin:${pkgs.nushell}/bin
''
