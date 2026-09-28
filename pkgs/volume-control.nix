{
  pkgs,
  lib,
}:
pkgs.runCommand "volume-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nushell pkgs.wireplumber pkgs.pipewire pkgs.sound-theme-freedesktop];
  meta.mainProgram = "volume-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/volume-control \
    --add-flags ${./volume-control.nu} \
    --suffix PATH : ${lib.getExe' pkgs.wireplumber "wireplumber"}:${lib.getExe' pkgs.pipewire "pipewire"}:${pkgs.nushell}/bin \
    --set SOUND_THEME_PATH ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop
''
