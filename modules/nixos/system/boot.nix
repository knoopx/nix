{
  pkgs,
  config,
  lib,
  ...
}: let
  msg = pkgs.stdenvNoCC.mkDerivation {
    name = "message.txt";
    phases = ["buildPhase"];
    buildPhase = with config.defaults; ''
      ${lib.getExe pkgs.gum} style \
        --border-foreground '#${colorScheme.palette.base08}' --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        'This device is property of ${fullName}' \
        'If found please contact ${primaryEmail}' > $out
    '';
  };
in {
  boot.initrd.preLVMCommands = ''
    cat "${msg}"
  '';

  boot.kernelParams = ["usbcore.autosuspend=-1"];
}
