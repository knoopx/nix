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

  theme = pkgs.stdenv.mkDerivation {
    name = "plymouth-theme-custom";
    src = pkgs.adi1090x-plymouth-themes;
    buildInputs = [pkgs.plymouth pkgs.lutgen];
    installPhase = ''
      mkdir -p $out/share/plymouth/themes/custom
      cp -r $src/share/plymouth/themes/cuts/* $out/share/plymouth/themes/custom/
      lutgen apply -n 0 -l 4 -L 0.5 -s 512 $out/share/plymouth/themes/custom/*.png -- ${builtins.concatStringsSep " " (builtins.attrValues config.defaults.colorScheme.palette)};
      mv $out/share/plymouth/themes/custom/cuts.script $out/share/plymouth/themes/custom/custom.script
      mv $out/share/plymouth/themes/custom/cuts.plymouth $out/share/plymouth/themes/custom/custom.plymouth
    '';
  };
in {
  boot = {
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

    kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false";
      "fs.suid_dumpable" = 0;
    };

    kernelPackages = pkgs.linuxPackages_zen;

    plymouth = {
      enable = true;
      extraConfig = ''
        ShowDelay=0
      '';
      theme = lib.mkForce "custom";
      themePackages = [theme];
    };

    initrd = {
      # systemd.enable = true;
      preLVMCommands = ''
        cat "${msg}"
      '';
    };

    kernelParams = [
      "usbcore.autosuspend=-1"
    ];
  };
}
