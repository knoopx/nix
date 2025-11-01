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
      theme = lib.mkForce "cuts";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["cuts"];
        })
      ];
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
