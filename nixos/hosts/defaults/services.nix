{
  pkgs,
  lib,
  defaults,
  ...
}: {
  services = {
    timesyncd.enable = lib.mkDefault true;
    fwupd.enable = true;
    printing.enable = false;

    xserver = {
      xkb.layout = defaults.keyMap;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    libinput.enable = false;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
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
