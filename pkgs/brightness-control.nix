{
  pkgs,
  lib,
}:
pkgs.runCommand "brightness-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "brightness-control";
} ''
  mkdir -p $out/bin
  cp ${./brightness-control.nu} $out/bin/brightness-control.nu
  chmod +x $out/bin/brightness-control.nu
  makeWrapper $out/bin/brightness-control.nu $out/bin/brightness-control \
    --suffix PATH : ${lib.getExe pkgs.brightnessctl}:${lib.getExe' pkgs.pipewire "pipewire"}:${pkgs.nushell}/bin:${pkgs.brightnessctl}/bin \
    --set SOUND_THEME_PATH ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop
''
