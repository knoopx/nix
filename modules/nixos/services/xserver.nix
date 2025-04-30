{
  lib,
  pkgs,
  ...
}: {
  services = {
    xserver = {
      displayManager = {
        # gdm = {
        #   enable = true;
        #   wayland = true;
        #   autoSuspend = false;
        # };
      };
    };
  };

  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };

  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${lib.getExe pkgs.greetd.regreet}";
        user = "greeter";
      };
    };
  };

  programs.regreet = {
    enable = true;
  };
}
