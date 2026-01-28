{
  pkgs,
  lib,
  ...
}: {
  services = {
    timesyncd.enable = lib.mkDefault true;
    fwupd.enable = true;
    printing.enable = false;
    libinput.enable = true; # required for niri mouse handling

    atd.enable = true;
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
      packages = with pkgs; [
        darkman
        dconf
        gcr
        gnome-keyring
        gvfs
        udisks2
      ];
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

    fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "1h";
      jails = {
        sshd.settings = {
          backend = "systemd";
          mode = "aggressive";
        };
      };
    };
  };
}
