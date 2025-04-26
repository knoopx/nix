{
  pkgs,
  lib,
  ...
}: {
  services = {
    timesyncd.enable = lib.mkDefault true;
    fwupd.enable = true;
    printing.enable = false;
    libinput.enable = false;

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
