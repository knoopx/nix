{ pkgs, lib }:

pkgs.runCommand "volume-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "volume-control";
} ''
  mkdir -p $out/bin
  cp ${./volume-control.nu} $out/bin/volume-control.nu
  chmod +x $out/bin/volume-control.nu
  makeWrapper $out/bin/volume-control.nu $out/bin/volume-control \
    --suffix PATH : ${lib.getExe' pkgs.wireplumber "wireplumber"}:${lib.getExe' pkgs.pipewire "pipewire"}:${pkgs.nushell}/bin \
    --set SOUND_THEME_PATH ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop
''