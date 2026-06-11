{ pkgs
, lib
, config
, ...
} @ inputs:
let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in
{
  imports =
    [
      ./boot.nix
      ./hardware.nix
      ./services.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  system.stateVersion = "26.11";

  networking.hostName = "hi10max";

  services.iio-niri = {
    enable = true;
    extraArgs = [ "--monitor" "eDP-1" ];
  };

  hardware.sensor.iio.enable = true;

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.wifi = lib.mkForce true;
  defaults.bluetooth = lib.mkForce true;
  defaults.display.idleTimeout = lib.mkForce (15 * 60);
  defaults.display.width = lib.mkForce 2880;
  defaults.display.height = lib.mkForce 1920;
  defaults.display.columnWidthPercentPresets = lib.mkForce [ 0.5 0.75 ];

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];

    programs.vicinae.settings.launcher_window.layer_shell = lib.mkForce {
      enabled = true;
      layer = "overlay";
      keyboard_interactivity = "exclusive";
    };

    programs.niri = {
      settings = {
        input = {
          tablet.map-to-output = "eDP-1";
          touch.map-to-output = "eDP-1";
        };

        outputs = {
          "eDP-1" = {
            transform.rotation = 270;
            scale = 1.5;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };
        };
      };
    };

    services.astal-shell.quickSettings = lib.mkForce [
      {
        id = "tablet-mode";
        icon = "input-keyboard-symbolic";
        label = "Tablet Mode";
        command = [ "tablet-mode-control" "toggle" ];
        confirm = false;
      }
      {
        id = "shutdown";
        icon = "system-shutdown-symbolic";
        label = "Shutdown";
        command = [ "systemctl" "poweroff" ];
        confirm = true;
      }
      {
        id = "reboot";
        icon = "system-reboot-symbolic";
        label = "Reboot";
        command = [ "systemctl" "reboot" ];
        confirm = true;
      }
      {
        id = "logout";
        icon = "system-log-out-symbolic";
        label = "Logout";
        command = [ "niri" "msg" "action" "quit" "-s" ];
        confirm = true;
      }
    ];

    systemd.user.services.wvkbd = {
      Unit = {
        Description = "wvkbd on-screen keyboard";
        After = [ "niri.service" ];
      };
      Service = {
        ExecStart = "${pkgs.wvkbd}/bin/wvkbd-mobintl --hidden";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  };
}
