{
  pkgs,
  lib,
  config,
  ...
} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in {
  imports =
    [
      ./boot.nix
      ./display.nix
      ./hardware.nix
      ./services.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  system.stateVersion = "25.11";

  networking.hostName = "minibookx";

  services.iio-niri = {
    enable = true;
    extraArgs = ["--monitor" "DSI-1"];
  };

  hardware.sensor.iio.enable = true;

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.wifi = lib.mkForce true;
  defaults.bluetooth = lib.mkForce true;
  defaults.display.width = lib.mkForce 1920;
  defaults.display.height = lib.mkForce 1200;
  defaults.display.idleTimeout = lib.mkForce 60; # 1 minute for battery conservation
  defaults.display.defaultColumnWidthPercent = lib.mkForce 1.0;
  defaults.display.columnWidthPercentPresets = lib.mkForce [0.5 0.75];
  defaults.display.windowRules = lib.mkForce [
    {
      excludes = [
        {app-id = "scrcpy";}
        {app-id = "org.gnome.Nautilus";}
        {app-id = "org.gnome.NautilusPreviewer";}
        {app-id = "io.bassi.Amberol";}
        {app-id = "Plexamp";}
        {app-id = "net.knoopx.camper";}
        {title = "[Ll]ogin";}
        {title = "Photos";}
        {title = "[Ss]ign-?in";}
        {title = "[Pp]assword";}
        {title = "Calendar";}
        {title = "Meet";}
        {title = "Notion";}
        {title = "Slack";}
        {title = "Reddit";}
        {title = "Telegram";}
        {title = "Discord";}
        {title = "WhatsApp";}
        {title = "Vicinae Launcher";}
        {title = "Gmail";}
        {title = "/dev/video0";}
      ];
      open-fullscreen = true;
    }
    {
      draw-border-with-background = false;
      geometry-corner-radius = {
        top-left = 8.0;
        top-right = 8.0;
        bottom-left = 8.0;
        bottom-right = 8.0;
      };
      clip-to-geometry = true;
    }
    {
      matches = [{is-floating = true;}];
      geometry-corner-radius = {
        top-left = 16.0;
        top-right = 16.0;
        bottom-left = 16.0;
        bottom-right = 16.0;
      };
    }
    {
      matches = [{app-id = "scrcpy";}];
      open-floating = false;
      default-column-width.fixed = 472;
      geometry-corner-radius = {
        top-left = 18.0;
        top-right = 18.0;
        bottom-left = 18.0;
        bottom-right = 18.0;
      };
    }
    {
      matches = [{app-id = "org.gnome.NautilusPreviewer";}];
      open-floating = true;
      default-window-height.proportion = 0.75;
    }
    {
      matches = [
        {app-id = "io.bassi.Amberol";}
        {app-id = "Plexamp";}
        {app-id = "net.knoopx.camper";}
      ];
      default-column-width.proportion = 0.25;
    }
    {
      matches = [{title = "/dev/video0";}];
      default-column-width.fixed = 400;
      default-window-height.fixed = 300;
      open-floating = true;
      open-focused = false;
      default-floating-position = {
        x = 12;
        y = 12;
        relative-to = "bottom-right";
      };
    }
    {
      matches = [
        {app-id = "scrcpy";}
        {title = "[Ll]ogin";}
        {title = "Photos";}
        {title = "[Ss]ign-?in";}
        {title = "[Pp]assword";}
        {title = "Calendar";}
        {title = "Meet";}
        {title = "Notion";}
        {title = "Slack";}
        {title = "Reddit";}
        {title = "Telegram";}
        {title = "Discord";}
        {title = "WhatsApp";}
        {title = "Vicinae Launcher";}
        {title = "Gmail";}
        {app-id = "org.gnome.Nautilus";}
      ];
      block-out-from = "screen-capture";
    }
    {
      matches = [{is-active = false;}];
      opacity = 0.9;
    }
    {
      matches = [{is-floating = true;}];
      opacity = 1.0;
    }
  ];

  home-manager.users.${config.defaults.username} = {
    imports = [
      ../../home/${config.defaults.username}.nix
    ];

    programs.niri = {
      settings = {
        input = {
          tablet.map-to-output = "DSI-1";
          touch.map-to-output = "DSI-1";
        };

        outputs = {
          "DSI-1" = {
            transform.rotation = 270;
            scale = 1.5;
            background-color = "#${config.defaults.colorScheme.palette.base02}";
          };
        };
      };
    };
  };
}
