{ lib
, pkgs
, config
, ...
}:
let
  pal = config.defaults.colorScheme.palette;
  # wvkbd CLI color flags (rrggbb hex), mapped from the base16 palette so the
  # on-screen keyboard matches the system color scheme.
  wvkbdColorArgs = lib.concatStringsSep " " [
    "--bg" pal.base01        # background
    "--fg" pal.base02        # normal keys
    "--fg-sp" pal.base03     # special keys
    "--press" pal.base04     # pressed normal keys
    "--press-sp" pal.base04  # pressed special keys
    "--swipe" pal.base07     # swiped keys (accent)
    "--swipe-sp" pal.base07
    "--text" pal.base05      # text on normal keys
    "--text-sp" pal.base05   # text on special keys
  ];
in {
  systemd.user.services.wvkbd = {
    description = "Wayland virtual keyboard (wvkbd deskintl)";
    after = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      # --auto: react to zwp_input_method_v2 activation — the keyboard
      # auto-appears when an app's text field gains focus and hides when it
      # loses focus. Requires GTK_IM_MODULE/QT_IM_MODULE=wayland (see
      # default.nix) so apps route IME activation to the compositor.
      ExecStart = "${pkgs.wvkbd-deskintl}/bin/wvkbd-deskintl --auto ${wvkbdColorArgs}";
      Restart = "always";
      # The Wayland display is not ready when the user manager first starts;
      # keep retrying (with a delay) until it is, instead of hitting the
      # default 5-in-10s start-limit and giving up for the boot.
      RestartSec = "3";
    };
    unitConfig = {
      StartLimitIntervalSec = "300";
      StartLimitBurst = "30";
    };
    wantedBy = [ "graphical-session.target" ];
  };

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
