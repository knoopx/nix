{
  pkgs,
  lib,
}:
pkgs.runCommand "brightness-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "brightness-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/brightness-control \
    --add-flags ${./brightness-control.nu} \
    --suffix PATH : ${lib.getExe pkgs.brightnessctl}:${lib.getExe' pkgs.pipewire "pipewire"}:${pkgs.nushell}/bin:${pkgs.brightnessctl}/bin \
    --set SOUND_THEME_PATH ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop
''
