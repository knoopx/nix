{...}: {
  boot = {
    plymouth.enable = false;
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        # useOSProber = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd.preLVMCommands = ''
      echo
      echo '################################### NOTICE ###################################'
      echo
      echo 'This device is property of ${defaults.full-name}'
      echo 'If found please contact ${defaults.personal-email}'
      echo
      echo '################################### NOTICE ###################################'
      echo
    '';
  };
}
