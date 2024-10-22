{pkgs, ...}: {
  # chaotic.scx.enable = true;
  # chaotic.scx.scheduler = "scx_simple";

  boot = {
    kernelModules = ["kvm-intel" "vfio-pci"];
    blacklistedKernelModules = ["snd_hda_intel"];
    extraModulePackages = [];
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    kernelPackages = pkgs.linuxPackages_zen;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    # .override {
    #   stdenv = pkgs.impureUseNativeOptimizations pkgs.linuxPackages_cachyos.stdenv;
    # };

    kernel.sysctl = {
      # "fs.inotify.max_user_watches" = 524288;
      #   # Enable MTU probing, as SteamOS does
      #   # See: https://github.com/ValveSoftware/SteamOS/issues/1006
      #   # See also: https://www.reddit.com/r/SteamDeck/comments/ymqvbz/ubisoft_connect_connection_lost_stuck/j36kk4w/?context=3
      #   "net.ipv4.tcp_mtu_probing" = true;

      #   # Helps with performance in proton, see https://archlinux.org/news/increasing-the-default-vmmax_map_count-value/
      #   "vm.max_map_count" = 2147483642;

      #   # Taken from steamos-customizations-jupiter package on the Steam Deck
      #   # 20-shed.conf
      #   "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      #   "kernel.sched_latency_ns" = 3000000;
      #   "kernel.sched_min_granularity_ns" = 300000;
      #   "kernel.sched_wakeup_granularity_ns" = 500000;
      #   "kernel.sched_migration_cost_ns" = 50000;
      #   "kernel.sched_nr_migrate" = 128;

      #   # 20-net-timeout.conf
      #   # This is required due to some games being unable to reuse their TCP ports
      #   # if they're killed and restarted quickly - the default timeout is too large.
      #   "net.ipv4.tcp_fin_timeout" = 5;
    };

    plymouth.enable = false;
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];

    # TODO:
    # MSI motherboard will wipe out boot entries if efi is not installed at fallback location
    # run `grub-install --removable ...` to also install grub at fallback location
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        # useOSProber = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
