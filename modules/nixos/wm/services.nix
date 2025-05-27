{pkgs, ...}: {
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };
  services.xserver.displayManager.gdm.enable = true;

  services = {
    # xserver.displayManager.lightdm = {
    # enable = true;
    # greeter.enable = false;
    # greeters.slick.enable = true;
    # };

    displayManager = {
      sessionPackages = with pkgs; [
        niri
      ];
      defaultSession = "niri";
    };
    gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      evolution-data-server.enable = true;
    };
  };
}
