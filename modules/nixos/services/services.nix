{
  pkgs,
  defaults,
  lib,
  ...
}: {
  services = {
    timesyncd.enable = lib.mkDefault true;
    fwupd.enable = true;
    printing.enable = false;
    libinput.enable = false;
    gvfs.enable = true;
    colord.enable = false;
    hardware.bolt.enable = false;
    # geoclue2.enable = false;
    # udisks2.enable = false;
    # upower.enable = false;

    xserver = {
      enable = true;
      xkb.layout = defaults.keyMap;
      excludePackages = [pkgs.xterm];
    };

    pipewire = {
      enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
  };
}
