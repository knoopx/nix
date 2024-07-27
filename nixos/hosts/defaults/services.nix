{
  pkgs,
  lib,
  defaults,
  ...
}: {
  services = {
    xserver = {
      xkb.layout = defaults.keyMap;
    };

    timesyncd.enable = lib.mkDefault true;
    fwupd.enable = true;
    printing.enable = false;

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
