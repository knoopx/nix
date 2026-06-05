{
  pkgs,
  lib,
  ...
}:
pkgs.runCommand "dashboard"
{
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "dashboard";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/dashboard \
    --add-flags ${./dashboard.nu} \
    --set LOGO_PATH ${../modules/nixos/defaults/logo.ascii} \
    --suffix PATH : ${lib.getExe (pkgs.callPackage ./events.nix {})}:${lib.getExe (pkgs.callPackage ./inbox.nix {})}:${lib.getExe (pkgs.callPackage ./project-summary.nix {})}:${pkgs.gum}/bin:${pkgs.nushell}/bin
''
