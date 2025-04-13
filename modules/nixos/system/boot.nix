{
  pkgs,
  defaults,
  lib,
  ...
}: let
  msg = pkgs.stdenvNoCC.mkDerivation {
    name = "message.txt";
    phases = ["buildPhase"];
    buildPhase = with defaults; ''
      ${lib.getExe pkgs.gum} style \
        --border-foreground '#${colorScheme.palette.base08}' --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        'This device is property of ${full-name}' \
        'If found please contact ${primary-email}' > $out
    '';
  };
in {
  boot.initrd.preLVMCommands = ''
    cat "${msg}"
  '';
}
