{pkgs}:
pkgs.runCommand "virtual-keyboard-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  # nushell runs the script; systemd provides systemctl (service start/stop);
  # libnotify provides notify-send (mako notifications).
  runtimeInputs = [pkgs.nushell pkgs.systemd pkgs.libnotify];
  meta.mainProgram = "virtual-keyboard-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/virtual-keyboard-control \
    --add-flags ${./virtual-keyboard-control.nu} \
    --suffix PATH : ${pkgs.systemd}/bin:${pkgs.libnotify}/bin
''
