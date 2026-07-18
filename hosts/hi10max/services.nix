{ lib
, pkgs
, config
, ...
}: {
  services = {
    power-profiles-daemon.enable = true;
    resolved.enable = lib.mkDefault true;

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = lib.mkForce "yes";
        PasswordAuthentication = false;
      };
    };

    dbus.packages = with pkgs; [
      feedbackd
    ];

    btrfs.autoScrub.enable = lib.mkForce false;

    displayManager = {
      autoLogin.user = config.defaults.username;
      defaultSession = "phosh";
    };

    xserver.desktopManager.phosh = {
      enable = true;
      user = config.defaults.username;
      group = "users";
    };

    keyd = {
      keyboards = {
        hi10max = {
          ids = [ "0001:0001" ];
          settings = {
            main = {
              leftalt = "overload(meta, M-.)";
              leftmeta = "leftalt";
            };
          };
        };
      };
    };
  };
}
